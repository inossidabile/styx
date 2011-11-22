require 'styx/engine'
require 'styx/helpers'
require 'styx/forms'
require 'styx/initializer'

ActionController::Base.send :include, Styx::Helpers
# ActionController::Base.send :include, Styx::Forms
# ActionController::Base.send :include, Styx::Initializer