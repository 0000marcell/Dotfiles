#ember-rails-new
#ember-rails-deploy-to-heroku
#ember-rails-heroku-deploy
#ember-rails-resource
#ember-deploy

# ember deploy install ember deploy for s3
function ember-deploy
	ember install ember-cli-deploy
	ember install ember-cli-deploy-build
	ember install ember-cli-deploy-revision-data
	ember install ember-cli-deploy-display-revisions
	ember install ember-cli-deploy-gzip
	ember install ember-cli-deploy-s3-index
	ember install ember-cli-deploy-s3
	cp ~/.config/fish/functions/ember-rails/deploy.js ./
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

function ember-rails-new
	set_color purple
	echo 'installing rails without bundle'
	rails new $argv[1] --skip-bundle
	set_color purple
	echo 'cd into new rails app'
	cd $argv[1]
	set_color purple
	echo 'copying gemfile and config/application.rb'
	cp $FISH_DIR/functions/ember-rails/Gemfile ./
	cp $FISH_DIR/functions/ember-rails/application.rb ./config/
	bundle install --without production
	ember new frontend --skip-git
	rails generate ember:init
	cd frontend
	ember install ember-cli-rails-addon
	ember g adapter application
	set_color purple
	echo 'fixing adapter'
	printf "import DS from 'ember-data';

export default DS.RESTAdapter.extend({
	namespace: 'api', 
	shouldReloadAll: function(){
		return true;
	},
	shouldBackgroundReloadRecord:function(){
		return false;
	}
});" > app/adapters/application.js
	cd ..
	printf "Rails.application.routes.draw do\n\tmount_ember_app :frontend, to: '/'\nend" > config/routes.rb
	rake ember:install
	git init
	echo "frontend/node_modules/*" >> .gitignore
	echo "frontend/bower_components/*" >> .gitignore
	git add --all
	git commit -m 'new ember rails app'
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

function ember-rails-resource
	rails g scaffold api/todo title isCompleted:boolean
	set_color purple
	echo "changing controller"
	printf "class Api::TodosController < ApplicationController
	protect_from_forgery :except => :create
  before_action :set_api_todo, only: [:show, :edit, :update, :destroy]

  # GET /api/todos
  def index
    @api_todos = Api::Todo.all
		render json: @api_todos
  end

  # GET /api/todos/1
  def show
		render json: @api_todo
  end

  # GET /api/todos/new
  def new
    @api_todo = Api::Todo.new
  end

  # GET /api/todos/1/edit
  def edit
  end

  # POST /api/todos
  def create
    @api_todo = Api::Todo.new(api_todo_params)

    if @api_todo.save
			head :no_content
    else
			render json: @api_todo, status: :created, location: @api_todo
    end
  end

  # PATCH/PUT /api/todos/1
  def update
		@api_todo = Api::Todo.find(params[:id])
    if @api_todo.update(api_todo_params)
			head :no_content
    else
			render json: @api_todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/todos/1
  def destroy
    @api_todo.destroy
		head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_todo
      @api_todo = Api::Todo.find(params[:id])
    end

    # Only allow a trusted parameter white list through.
    def api_todo_params
			puts 'set api todo params'
      params.require(:todo).permit(:title, :isCompleted)
    end
end" > app/controllers/api/todos_controller.rb
	rake db:migrate
	rails g serializer api/todo
	set_color purple
	echo 'fixing serializer'
	printf "class Api::TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :isCompleted
end" > app/serializers/api/todo_serializer.rb
	
	set_color purple
	echo 'backend done!'

	echo 'creating model and adapter on frontend'
	cd frontend
	ember g model todo title:string isCompleted:boolean
	
	set_color purple
	echo 'INDEX'
	ember g route todos/index
	printf "<h1>Index</h1>
<ul>
	<li>
		{{#each model as |todo|}}
			<p>{{todo.title}}</p>
			<p>{{todo.isCompleted}}</p>
			{{#link-to 'todos.show' todo}}Show{{/link-to}}
			{{#link-to 'todos.edit' todo}}Edit{{/link-to}}
      <button {{action 'deleteTodo' todo.id}}>delete</button>
		{{/each}}
	</li>
</ul>
{{#link-to 'todos.create'}}Create{{/link-to}}
" > app/templates/todos/index.hbs 
	printf "import Ember from 'ember';

export default Ember.Route.extend({
	model(){
		return this.store.findAll('todo');
	}
}); " > app/routes/todos/index.js

	set_color purple
	echo 'CREATE'
	ember g route todos/create
	printf "<label>title</label>
{{input type='text' value=title}}
<label>is completed</label>
{{input type='text' value=isCompleted}}
<button {{action 'createTodo'}}>create</button> " > app/templates/todos/create.hbs

	ember g controller todos/create
	printf "import Ember from 'ember';

export default Ember.Controller.extend({
	actions: {
		createTodo(){
			var todo = this.store.createRecord('todo');	
			todo.set('title', this.get('title'));
			todo.set('isCompleted', this.get('isCompleted'));
			todo.save().then((resp) => {
				this.transitionToRoute('todos.index');
			}).catch((err) => {
				alert('something went wrong when saving');		
				console.log(err.responseJSON.errors);
			});
		}
	}
});" > app/controllers/todos/create.js
	ember g controller todos/index
	printf "import Ember from 'ember';

export default Ember.Controller.extend({
	actions: {
		deleteTodo(id){
			this.store.findRecord('todo', id).then(todo => {
				todo.destroyRecord().then((resp) => {
				}).catch((err) => {
					console.log(err);
				});
			}).catch((err) => {
				console.log(err);
			});
		}	
	}
});" > app/controllers/todos/index.js
	set_color purple
	echo "SHOW"
	ember g route todos/show --path=/show/:id
	printf "<h1>Show</h1>
<h1>{{model.title}}</h1>" > app/templates/todos/show.hbs
	printf "import Ember from 'ember';

export default Ember.Route.extend({
	model(params){
		return this.store.find('todo', params.id);
	}
});" > app/routes/todos/show.js 
	
	set_color purple 
	echo 'EDIT'
	ember g route todos/edit --path=/edit/:id
	printf "<label>title</label>
{{input type='text' value=title placeholder=model.title}}
<label>is completed</label>
{{input type='text' value=isCompleted placeholder=model.isCompleted}}
<button {{action 'editTodo' model}}>Edit</button>
" > app/templates/todos/edit.hbs
	
	ember g controller todos/edit
	printf "import Ember from 'ember';

export default Ember.Controller.extend({
	actions: {
		editTodo(model){
			this.store.findRecord('todo', model.id).then(todo => {
				todo.set('title', this.get('title'));
				todo.set('isCompleted', this.get('isCompleted'));
				todo.save().then((resp) => {
					this.transitionToRoute('todos.index');
				}, (err) => {
					console.log(err);
				});
			});	
		}
	}
});" > app/controllers/todos/edit.js
end
