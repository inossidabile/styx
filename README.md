# Styx

Bridge between Server (Rails) side and Client (JS) side which is divided into several modules:

* **Helpers**: set of helpers to support all other modules.
* **Initializer**: organizes JS into bootstrap classes and allows you to pass data from controller/view.
* **Forms**: remote validation engine.

[![Travis CI](https://secure.travis-ci.org/inossidabile/styx.png)](https://travis-ci.org/inossidabile/styx)
[![Code Climate](https://codeclimate.com/github/inossidabile/styx.png)](https://codeclimate.com/github/inossidabile/styx)


## Installation

In your Gemfile, add this line:

    gem 'styx'
    
In your assets application.js include appropriate libs:

    //= require styx           <- Helpers and Initializers
    //= require styx.forms     <- Forms

## Basic Usage

```ruby
# app/controllers/foos_controller.rb
class FoosController < ApplicationController
  include Styx::Initializer
  include Styx::Forms
end
```

Include modules to ApplicationController if you want to use it everywhere.


### Initializer

In common each controller in Rails comes with *app/assets/javascripts/controller_name.js.coffee*. 
**Styx.Initializer** allows you to define bootstrap logic for each Rails action separately and 
pass some data from server right into it.

To enable initializers bootstrap, add *styx_initialize* call into your layout:

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
    

### Forms

Forms assist *form_for @foo, :remote => true* to automate server response and UJS callbacks. 

If everything went smooth you can respond with URL for redirect or with JSON for your callback.
If validation failed appropriate form fields will be wrapped in a native way:

    <div class="field_with_errors">
     
### Client side

```erb
# app/views/foos/new.html.erb
<%= form_for @foo, :remote => true, :html => {:id => 'foo_form'} do |f| %>
  <%= f.text_field :f.title %>
<% end %>
```

```javascript
// Light case
Styx.Forms.validate('#foo_form')


// Heavy case
success_callback = function(data) {}    // Form validated and stored. Data is what you pass from server.
error_callback = function() {}          // Form wasn't validated

Styx.Forms.validate('#foo_form', success_callback, error_callback)
```

Note that if success_callback was not given but server responded with some data, **Styx.Forms** will try
to evaluate it as URL and will try to redirect to it.

Javascript part goes best with **Styx.Initializers**.

### Server side

In common you just want to store your form as a model. **Styx.Forms** come with a predefined helper for this:

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

*response* parameter can also be passed as lambda{|x|}.

### What if the form was invalid?

First of all, *success_callback* and server-side block wouldn't be called. *response* wouldn't be return to JS.
Instead validation errors for @entity will be returned. All invalid form fields will be wrapped with 

    <div class="field_with_errors">
    
### Server side without models

You can use two helpers to work without models (i.e. to serve login form):

```ruby
  styx_form_respond_success(data)
```

```ruby
  styx_form_respond_failure(entity_name, fields) # fields = {'field_name' => 'error message'}
```

JS part will concatenate *entity_name* + *field_name* to locate which fields have to be marked as invalid. 
So if you don't have entity, simply pass empty string as the first arg.

## Maintainers

* Boris Staal, [@inossidabile](http://staal.io)

## License

It is free software, and may be redistributed under the terms of MIT license.
