module Styx
  module Initializer
    def self.included base
      base.send(:include, InstanceMethods)
      base.class_eval do
        helper_method :styx_initialize, :styx_initialize_with
        before_filter { @styx_initialize_with = {} }
      end
    end

    module InstanceMethods
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
end