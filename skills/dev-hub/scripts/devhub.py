#!/usr/bin/env python3
"""Call the Decisiv Dev Hub JSON API.

The harness cannot run curl, so this is the way in. It supplies the token and
prints the answer as JSON.

The port must be given, with --port or DEV_HUB_PORT. The app is started by hand
and several checkouts of it can run side by side, so guessing which one was
meant risks talking to the wrong copy, and changing the wrong piece of work.
"""

import argparse
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request

APP_DIR = os.environ.get("DEV_HUB_DIR", "/home/mmc/decisiv_dev_hub")
TIMEOUT = 60 * 45  # the test suite is allowed to be slow


def fail(message, hint=None):
    out = {"error": "skill_error", "message": message}
    if hint:
        out["hint"] = hint
    print(json.dumps(out, indent=2))
    sys.exit(1)


def rails(task):
    """Ask the app itself for something, by running a rake task in its directory."""
    if not os.path.isdir(APP_DIR):
        fail(f"The app is not at {APP_DIR}",
             "Set DEV_HUB_DIR to where decisiv_dev_hub is checked out.")
    try:
        done = subprocess.run(["bin/rails", task], cwd=APP_DIR,
                              capture_output=True, text=True, timeout=120)
    except FileNotFoundError:
        fail(f"No bin/rails in {APP_DIR}", "Is DEV_HUB_DIR pointing at the app?")
    except subprocess.TimeoutExpired:
        fail("bin/rails took too long to answer")
    if done.returncode != 0:
        fail(f"bin/rails {task} failed", done.stderr.strip()[-500:])
    # Rails prints warnings on stdout, so take the last line that looks like output.
    lines = [line.strip() for line in done.stdout.splitlines() if line.strip()]
    return lines[-1] if lines else ""


def token():
    given = os.environ.get("DEV_HUB_TOKEN")
    if given:
        return given
    found = rails("api:token")
    if not re.fullmatch(r"[0-9a-f]{64}", found or ""):
        fail("Could not read the API token",
             "Run bin/rails api:token in the app directory and set DEV_HUB_TOKEN.")
    return found


def base_url(port):
    """Where to send requests. The port is required and is never guessed."""
    given = os.environ.get("DEV_HUB_URL")
    if port is None and given:
        return given.rstrip("/")

    if port is None:
        port = os.environ.get("DEV_HUB_PORT")

    if port is None or str(port).strip() == "":
        fail("No port given",
             "Ask the user which port the Dev Hub is running on, then pass "
             "--port N (or set DEV_HUB_PORT). Several checkouts can run at "
             "once, so the right one cannot be guessed.")

    try:
        number = int(str(port).strip())
    except ValueError:
        fail(f"{port!r} is not a port number", "Pass a number, such as --port 3000.")

    return f"http://localhost:{number}"


def confirm_app(url):
    """Check that something answering on this port really is the Dev Hub.

    A port is easy to mistype and plenty of other things listen on 3000, so
    this is asked once per call rather than letting a stray app be fed a task
    id it knows nothing about.
    """
    try:
        request = urllib.request.Request(f"{url}/api/v1", method="GET")
        with urllib.request.urlopen(request, timeout=5) as answer:
            body = json.loads(answer.read())
    except urllib.error.HTTPError as error:
        if error.code == 404:
            fail(f"Something is on {url}, but it has no JSON API",
                 "That is most likely a Dev Hub checkout from before the API "
                 "was added. Ask the user for the port of one running a branch "
                 "that has it. Do not start a server.")
        fail(f"Something is on {url} but it did not answer as the Dev Hub "
             f"(HTTP {error.code})", "Check the port with the user.")
    except Exception:
        fail(f"Nothing is answering on {url}",
             "Ask the user which port the app is on. Do not start a server.")

    if body.get("name") != "Decisiv Dev Hub API":
        fail(f"{url} is running something else, not the Dev Hub",
             "Check the port with the user.")


def call(method, path, params, data, url, auth):
    if not path.startswith("/"):
        path = "/" + path
    if not path.startswith("/api/"):
        path = "/api/v1" + path

    if params:
        from urllib.parse import urlencode
        pairs = []
        for item in params:
            name, _, value = item.partition("=")
            pairs.append((name, value))
        path += ("&" if "?" in path else "?") + urlencode(pairs)

    body = None
    headers = {"Accept": "application/json", "Authorization": f"Bearer {auth}"}
    if data:
        body = data.encode() if isinstance(data, str) else json.dumps(data).encode()
        headers["Content-Type"] = "application/json"

    request = urllib.request.Request(url + path, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(request, timeout=TIMEOUT) as answer:
            return answer.status, answer.read().decode()
    except urllib.error.HTTPError as error:
        return error.code, error.read().decode()
    except urllib.error.URLError as error:
        fail(f"Could not reach {url}: {error.reason}")


def main():
    parser = argparse.ArgumentParser(description="Call the Decisiv Dev Hub API")
    parser.add_argument("path", help="/projects, or a full /api/v1/... path")
    parser.add_argument("-p", "--port", help="Port the Dev Hub is running on. Required "
                                            "unless DEV_HUB_PORT or DEV_HUB_URL is set")
    parser.add_argument("-X", "--method", default="GET",
                        help="GET (default), POST, PATCH, DELETE")
    parser.add_argument("-q", "--param", action="append", default=[],
                        metavar="NAME=VALUE", help="Query parameter, repeatable")
    parser.add_argument("-d", "--data", help="JSON body, as a string")
    parser.add_argument("-f", "--field", action="append", default=[],
                        metavar="NAME=VALUE", help="Body field, repeatable")
    parser.add_argument("--raw", action="store_true", help="Do not pretty print")
    args = parser.parse_args()

    data = args.data
    if args.field:
        built = {}
        for item in args.field:
            name, _, value = item.partition("=")
            # task[title]=x nests, so the API's strong parameters see what they expect.
            match = re.fullmatch(r"(\w+)\[(\w+)\]", name)
            if match:
                built.setdefault(match.group(1), {})[match.group(2)] = value
            else:
                built[name] = value
        data = json.dumps(built)

    url = base_url(args.port)
    confirm_app(url)
    status, text = call(args.method.upper(), args.path, args.param, data, url, token())

    if args.raw:
        print(text)
    else:
        try:
            print(json.dumps(json.loads(text), indent=2))
        except json.JSONDecodeError:
            # An HTML page means the path was wrong, and printing the whole
            # thing would bury the answer, so only the gist is shown.
            gist = re.search(r"<h2>(.*?)</h2>", text, re.S)
            message = gist.group(1).strip() if gist else text[:300]
            print(json.dumps({"error": "not_json", "status": status,
                              "message": re.sub(r"\s+", " ", message)}, indent=2))

    sys.exit(0 if status < 400 else 1)


if __name__ == "__main__":
    main()
