require 'styx'

class TestsController < ActionController::Base

  append_view_path Styx::Engine.paths['app/views']

  include Styx::Initializer
  include Styx::Forms

  def index
    styx_initialize_with :data => 'test'
  end
end