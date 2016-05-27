function rails-lolcat
	rails s 2>&1 | lolcat
end

function rails-test
	bundle exec rake test
end

function rails-db
	sqlite3 db/development.sqlite3
end

function rails-console
	rails console --sandbox
end

function rails-db-reset
	bundle exec rake db:migrate:reset
end

function rails-db-migrate
	bundle exec rake db:migrate
end

function rails-db-seed
	bundle exec rake db:migrate:reset
	bundle exec rake db:seed
end

function rails-routes
	rake routes
end

function bake
	bundle exec rake $argv[1]
end

# show information about gems
function rails-env
	gem environment
end

# show information about installed gems for that project
function rails-gems
	bundle show
end
