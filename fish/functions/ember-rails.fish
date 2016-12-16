#ember-rails-deploy-to-heroku
#ember-rails-heroku-deploy
#ember-deploy
#ember-server ( ember server using rails )
#rails-server ( rails server using ember )

# install all ember deploy dependencies
function ember-install-deploy
  ember install ember-cli-deploy
  ember install ember-cli-deploy-build
  ember install ember-cli-deploy-revision-data
  ember install ember-cli-deploy-display-revisions
  ember install ember-cli-deploy-gzip
  ember install ember-cli-deploy-s3-index
  ember install ember-cli-deploy-s3
end

# copy ember default project, remember of rm symlinked node_modules folder after using
function ember-copy
	rsync -av --progress ~/documents/github/sandbox/ember-default-materialize ./ember-default --exclude node_modules
	ln -s ./ember-default-materialize/node_modules ./ember-default/node_modules
end

# ember server
function ember-server
	ember server --proxy http://0.0.0.0:3000
end

# ember fastboot
function ember-serve-fastboot
  ember fastboot --serve-assets
end

# rails server
function rails-server
	rails server --binding 0.0.0.0
end

# deploy ember app to amazon s3
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
	npm cache clean and bower cache clean
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
