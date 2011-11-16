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
        mask = mask.split('#')

        c = mask[0]
        a = mask[1]

        flag = true

        flag = false if !c.blank? && c != controller_path
        flag = false if !a.blank? && a != action_name

        flag
      end

      def this_namespace?(namespace)
        current = controller_path.split('/').first

        return namespace == current
      end
    end
  end
end