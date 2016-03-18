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
	bundle exec rake db:seed
end

function rails-routes
	rake routes
end

function bake
	bundle exec rake $argv[1]
end
