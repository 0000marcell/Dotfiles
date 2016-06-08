#ember-rails-deploy-to-heroku
#ember-rails-heroku-deploy
#ember-deploy

# ember deploy install ember deploy for s3
function ember-deploy
	ember deploy production --verbose --activate=true
end

# ember api
function ember-api
	open http://emberjs.com/api/
end

# rails api
function rails-api
	open http://api.rubyonrails.org/
end

# show latest versions of ember rails and ember-data
function ember-rails-latest
 open http://rubyonrails.org/
 open http://emberjs.com/builds/
 open https://github.com/emberjs/data/releases
 open https://github.com/ember-cli/ember-cli/releases/tag/v2.5.0
end

# update ember and ember-data, see latest version with ember-rails-latest 2.5.6
function ember-rails-update-ember
	bower install ember#$argv[1] --save
end

# see which version with ember-rails-latest 2.3.4
function ember-rails-update-ember-data
	ember install ember-data@$argv[1]
end

# upate ember ember-cli
function ember-rails-update-ember-cli
	npm uninstall -g ember-cli
	npm cache clean && bower cache clean
	npm install -g ember-cli@$argv[1]
end

function ember-rails-deploy-to-heroku
	rails generate ember:heroku
	git add --all
	git commit -m 'preparing to deploy to heroku'
	heroku create $argv[1]
	heroku buildpacks:add --index 1 heroku/nodejs
	heroku buildpacks:add --index 2 heroku/ruby
	heroku config:set NPM_CONFIG_PRODUCTION=false
	heroku config:unset SKIP_EMBER
	git push heroku master
	heroku run rake db:schema:load
	heroku open
end

function ember-rails-heroku-deploy
	ember-rails $argv[1]
	ember-rails-deploy-to-heroku $argv[1]
end
