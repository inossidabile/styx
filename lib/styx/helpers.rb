module Styx
  module Helpers
    def self.included base
      base.send(:include, InstanceMethods)
      base.class_eval do
        helper_method :this_page?, :this_namespace?
      end
    end

    module InstanceMethods
      def this_page?(mask)
        [*mask].any? do |m|
          c, a = m.to_s.split('#')
          c.presence == controller_name || a.presence == action_name
        end
      end

      def this_namespace?(namespace)
        namespace == controller_path.split('/').first
      end
    end
  end
end