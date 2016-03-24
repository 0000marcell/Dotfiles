function heroku-get-var
	heroku config:get $argv[1]
end

function heroku-set-var
	heroku config:set $argv[1]=$argv[2]
end

function heroku-migrate
	heroku run rake db:migrate
end

function heroku-console
	heroku run console --sandbox
end

function heroku-releases
	heroku releases
end

function heroku-git-log
	git ls-remote heroku
end
