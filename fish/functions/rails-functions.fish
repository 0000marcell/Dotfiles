function rails-db
	sqlite3 db/development.sqlite3
end

function rails-console
	rails console --sandbox
end
