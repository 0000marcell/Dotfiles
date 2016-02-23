function heroku-migrate
	heroku run rake db:migrate
end

function heroku-console
	heroku run console --sandbox
end
