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

    <head>
      <title>Rails Application</title>
      <%= stylesheet_link_tag    "application" %>
      <%= javascript_include_tag "application" %>
      <%= styx_initialize %>
      <%= csrf_meta_tags %>

Imagine you have controller *Foos* and therefore *app/assets/javascripts/foos.js.coffee* file.

```coffee-script
@Styx.Initializers.Foos =
  initialie: ->
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