Styx
========

Bridge between Server (Rails) side and Client (JS) side divided into several modules:

* **Helpers**: set of helpers to support all other modules.
* **Initializer**: organizes JS into bootstrap classes and allows you to pass data from controller/view.
* **Forms**: remote validaton engine.


Installation
------------

    $ gem install styx


Basic Usage
------------

```ruby
# app/controllers/foos_controller.rb
class FoosController < ApplicationController
  include Styx::Initializer
  include Styx::Forms
end
```

Include modules to ApplicationController if you want to use it everywhere.


Initializer
------------

In common each controller in Rails comes with *app/assets/javascripts/controller_name.js.coffee*. 
Styx.Initializer allows you to separately define bootstrap logic for each Rails action and pass
some data from server right in.

To enable initializers bootstrap, add *styx_initialize* line to your layout:

```erb
  <head>
    <title>Rails Application</title>
    <%= stylesheet_link_tag    "application" %>
    <%= javascript_include_tag "application" %>
    <%= styx_initialize %>
    <%= csrf_meta_tags %>
```

Imagine you have controller *Foos* and therefore *app/assets/javascripts/foos.js.coffee* file.

```coffee-script
@Styx.Initializers.Foos =
  initialize: ->
    console.log 'This will be called in foos#ANY action after <head> was parsed'
      
  index: (data) ->
    console.log 'This will be called in foos#index action after <head> was parsed'
    
  show: (data) -> 
    $ ->
      console.log 'This will be called in foos#show action after the page was loaded'
```

Note that any method besides common *initialize* has the *data* parameter. To pass some data to your
initializers you can use *styx_initialize_with* helper in your controller or views. Like that:

```ruby
# app/controllers/foos_controller.rb
class FoosController < ApplicationController
  def index
    styx_initialize_with :some => 'data', :and => {:even => 'more data'}
  end
end

# app/views/foos/index.html.erb
<%- styx_initialize_with :enabled => true %>
```

As the result *Styx.Initializers.Foos->index* will be called with data equal to 

    {some: data, and: {even: 'mode data'}, enabled: true}
    

Forms
------------

Forms assist *form_for @foo, :remote => true* to automate server response and UJS callbacks. 

If everything went smooth you can respond with URL for redirect or with JSON for your callback.
If validation failed appropriate form fields will be wraped with native 

    <div class="field_with_errors">
     
### Binding

```erb
# app/views/foos/new.html.erb
<%= form_for @foo, :remote => true, :html => {:id => 'foo_form'} do |f| %>
  <%= f.text_field :f.title %>
<% end %>
```

```javascript
# Light case
Forms.attach('#foo_form')


# Heavy case
success_callback = function(data) {}    # Form validated and stored. Data is what you pass from server.
error_callback = function() {}          # Form wasn't validated

Forms.attach('#foo_form', success_callback, error_callback)
```

Note that if success_callback was not given but server responded with some data, Styx.Forms will try
to evaluate it as URL and will try to redirect to it.

### Server side

In common you just want to store your form as model. Styx.Forms come with predefined helper for this:

```ruby
# app/controllers/foos_controller.rb
def create
  @entity  = Foo.new(params[:foo])
  response = foos_url                   # Return URL or anything for your custom callback
  
  styx_form_store_and_respond(@foo, response) do
    # this will be called after (and if) @foo was validated and saved
  end
end
```

*response* parameter can either be passed as lambda{|x|}.

### What if form was invalid?

First of all, *success_callback* and server-side block won't be called. *response* won't be return to JS.
Validation errors for @entity will be returned instead. All invalid form fields will be wraped with 

    <div class="field_with_errors">
    
### Server side without models

To work without models (i.e. to server login form) you can use two helpers

```ruby
  styx_form_respond_success(data)
```

```ruby
  styx_form_respond_failure(entity_name, fields) # fields = {'field_name' => 'error message'}
```

To choose which fields have to be marked as invalid JS part will concatenate entity_name + field _name. So if
you don't have entity, simply pass empty string as the first arg.