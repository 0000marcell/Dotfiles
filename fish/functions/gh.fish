function gh-create-repo
	if count $argv > /dev/null
		echo $GITHUB_USER
		echo $GITHUB_TOKEN
		curl -u "$GITHUB_USER:$GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"'$argv[1]'"}'
	else
		set_color red
		echo "my user name is $GITHUB_USER"	
	end
end

function gh-push-new-repo
	if count $argv > /dev/null
		echo "# thor-generators" >> README.md
		git init
		git add README.md
		git commit -m "first commit"	
		git remote add origin git@github.com:0000marcell/$argv[1].git
		git push -u origin master
	else
		set_color red
		echo 'pass the name of the remote repo'
	end
end

function gh-commit-push
	if count $argv > /dev/null
		git add --all
		git commit -m "$argv[1]"
		git push
	else
		set_color red
		echo 'put a msg to commit'
	end
end

function gh-commit
	git add --all
	git commit -m "$argv[1]"
end

function gh-new-branch
	git checkout -b $argv[1]
end

function gh-delete-branch
	git branch -D $argv[1]
end

function gh-reset
	if count $argv > /dev/null
		git reset --hard $argv[1]
	else
		echo "pass the commit hash"
	end
end

function gh-open 
	open https://github.com/0000marcell/$argv[1]	
end
