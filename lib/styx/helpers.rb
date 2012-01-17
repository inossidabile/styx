module Styx
  module Helpers
    extend ActiveSupport::Concern
    
    included do
      helper_method :this_page?, :this_namespace?
    end

    module InstanceMethods
      def this_page?(mask)
        [*mask].any? do |m|
          c, a = m.to_s.split('#')
          !(c.present? && c != controller_name || a.present? && a != action_name)
        end
      end

      def this_namespace?(namespace)
        # TODO: support nested namespaces?
        namespace == controller_path.split('/').first
      end
    end
  end
end