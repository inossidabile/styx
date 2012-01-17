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
        mask = [mask] unless mask.is_a?(Array)

        flag = false

        mask.each do |m|
          m = m.to_s.split('#')

          c = m[0]
          a = m[1]

          f = true

          f = false if !c.blank? && c != controller_name
          f = false if !a.blank? && a != action_name

          flag ||= f
        end

        flag
      end

      def this_namespace?(namespace)
        # TODO: support nested namespaces?
        current = controller_path.split('/').first

        return namespace == current
      end
    end
  end
end