#!/usr/bin/env python3
"""Rebuild references/endpoints.md from the app's own OpenAPI description.

The reference is generated rather than written by hand so it cannot drift from
what the app actually serves. Run this after the API gains or loses an endpoint.

    python3 ~/.claude/skills/dev-hub/scripts/regenerate_reference.py
"""

import os
import sys

import yaml

APP_DIR = os.environ.get("DEV_HUB_DIR", "/home/mmc/decisiv_dev_hub")
SPEC = os.path.join(APP_DIR, "doc/api/openapi.yaml")
OUT = os.path.expanduser("~/.claude/skills/dev-hub/references/endpoints.md")
VERBS = ["get", "post", "patch", "put", "delete"]
TAG_ORDER = ["Discovery", "Projects", "Tasks", "Agent", "Desktop", "Review", "Jira", "Configuration"]
SHAPES = ["Project", "ProjectDetailed", "Task", "TaskDetailed", "TaskInput", "Agent",
          "Commit", "RunningServer", "Feed", "Board", "Tag", "Error"]


def flat(text):
    return " ".join((text or "").split())


def main():
    if not os.path.exists(SPEC):
        sys.exit(f"No API description at {SPEC}. Set DEV_HUB_DIR.")

    spec = yaml.safe_load(open(SPEC))
    out = []

    def say(line=""):
        out.append(line)

    by_tag = {}
    for path, item in spec["paths"].items():
        for verb in VERBS:
            operation = item.get(verb)
            if operation:
                tag = (operation.get("tags") or ["Other"])[0]
                by_tag.setdefault(tag, []).append((verb.upper(), path, operation, item))

    say("# Dev Hub API: every endpoint")
    say()
    say("Generated from the app's own OpenAPI description. Paths below include the")
    say("`/api/v1` prefix; the helper script accepts them with or without it.")
    say()
    say("The port is required. Ask the user which port the Dev Hub is on, then pass")
    say("`--port N` or export `DEV_HUB_PORT`. Never start a server.")
    say()
    say("Call anything here with:")
    say()
    say("```bash")
    say("python3 ~/.claude/skills/dev-hub/scripts/devhub.py PATH --port N [-X METHOD] [-q k=v] [-f k=v]")
    say("```")
    say()

    for tag in TAG_ORDER + [t for t in by_tag if t not in TAG_ORDER]:
        if tag not in by_tag:
            continue
        say(f"## {tag}")
        say()
        for verb, path, operation, item in sorted(by_tag[tag], key=lambda entry: entry[1]):
            say(f"### `{verb} {path}`")
            say()
            say(operation.get("summary", "").strip())
            say()
            for para in (operation.get("description") or "").strip().split("\n\n"):
                if para.strip():
                    say(flat(para))
                    say()

            params = (item.get("parameters") or []) + (operation.get("parameters") or [])
            query = [p for p in params if isinstance(p, dict) and p.get("in") == "query"]
            if query:
                say("Query parameters:")
                say()
                for param in query:
                    schema = param.get("schema") or {}
                    bits = [schema["type"]] if schema.get("type") else []
                    if schema.get("enum"):
                        bits.append("one of " + ", ".join(f"`{e}`" for e in schema["enum"]))
                    if param.get("required"):
                        bits.append("required")
                    note = flat(param.get("description"))
                    say(f"- `{param['name']}` ({', '.join(bits) or 'string'})" + (f" - {note}" if note else ""))
                say()

            body = operation.get("requestBody")
            if body:
                schema = body["content"]["application/json"]["schema"]
                props = schema.get("properties") or {}
                required = schema.get("required") or []
                if props:
                    say("Body:")
                    say()
                    for name, prop in props.items():
                        if "$ref" in prop:
                            say(f"- `{name}` (object, see {prop['$ref'].split('/')[-1]} below)")
                        elif prop.get("properties"):
                            say(f"- `{name}`: " + ", ".join(f"`{k}`" for k in prop["properties"]))
                        else:
                            note = flat(prop.get("description"))
                            mark = " **required**" if name in required else ""
                            say(f"- `{name}` ({prop.get('type', 'string')}){mark}" + (f" - {note}" if note else ""))
                    say()

            codes = []
            for code, response in (operation.get("responses") or {}).items():
                note = response.get("$ref", "").split("/")[-1] if "$ref" in response else flat(response.get("description"))
                if note:
                    codes.append(f"`{code}` {note}")
            if codes:
                say("Answers: " + "; ".join(codes))
                say()

    say("## Record shapes")
    say()
    for name in SHAPES:
        schema = spec["components"]["schemas"].get(name)
        if not schema:
            continue
        say(f"### {name}")
        say()
        if schema.get("description"):
            say(flat(schema["description"]))
            say()
        if "allOf" in schema:
            say(f"Everything in {schema['allOf'][0]['$ref'].split('/')[-1]}, plus:")
            say()
            props = schema["allOf"][1].get("properties", {})
        else:
            props = schema.get("properties", {})
        for field, prop in props.items():
            kind = prop.get("type", "object")
            if isinstance(kind, list):
                kind = " or ".join(str(k) for k in kind)
            note = flat(prop.get("description"))
            say(f"- `{field}` ({kind})" + (f" - {note}" if note else ""))
        say()

    open(OUT, "w").write("\n".join(out))
    print(f"Wrote {OUT} ({len(out)} lines)")


if __name__ == "__main__":
    main()
