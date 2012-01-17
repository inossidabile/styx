module Styx
  module Initializer
    extend ActiveSupport::Concern
    
    included do
      helper_method :styx_initialize, :styx_initialize_with
      before_filter { @styx_initialize_with = {} }
    end
    
    def styx_initialize_with(data)
      @styx_initialize_with.merge! data
    end

    def styx_initialize()
      result = render_to_string :partial => 'styx/initializer', :locals => {
        :klass  => controller_path.gsub('/', '_').camelize,
        :method => action_name, 
        :data   => @styx_initialize_with
      }
      
      result.html_safe
    end
  end
end