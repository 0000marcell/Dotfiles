function ember-rails
	rails new $argv[1]
	cd $argv[1]
	cp $FISH_DIR/functions/ember-rails/Gemfile ./
	bundle install
	ember new frontend --skip-git
	rails generate ember:init
	cd frontend
	ember install ember-cli-rails-addon
	cd ..
	printf "Rails.application.routes.draw do\n\tmount_ember_app :frontend, to: '/'\nend" > config/routes.rb
	rake ember:install
	rails generate ember:heroku
	git init
	echo "frontend/node_modules/*" >> .gitignore
	echo "frontend/bower_components/*" >> .gitignore
	git add --all
	git commit -m 'new ember rails app'
	heroku create $argv[1]
	heroku buildpacks:add --index 1 heroku/nodejs
	heroku buildpacks:add --index 2 heroku/ruby
	heroku config:set NPM_CONFIG_PRODUCTION=false
	heroku config:unset SKIP_EMBER
	git push heroku master
end
