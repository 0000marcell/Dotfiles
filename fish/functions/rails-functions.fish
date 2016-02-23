function rails-db
	sqlite3 db/development.sqlite3
end

function rails-console
	rails console --sandbox
end

function rails-db-reset
	bundle exec rake db:migrate:reset
end

function rails-routes
	rake routes
end
