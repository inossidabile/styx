module Styx
  module Forms
    extend ActiveSupport::Concern

    module InstanceMethods
      def styx_form_store_and_respond(entity, data=nil, &block)
        response.content_type = Mime::TEXT

        if entity.save
          styx_form_respond_success(data, entity, &block)
        else
          styx_form_respond_failure(entity.class.name, entity.errors.messages)
        end
      end

      def styx_form_respond_failure(entity, errors)
        response.content_type = Mime::TEXT

        errors = Hash[*errors.map {|x| [x, nil]}.flatten] if errors.is_a?(Array)
        render :text => {:entity => entity.to_s.underscore.gsub('/', '_'), :messages => errors}.to_json, :status => :unprocessable_entity
      end

      def styx_form_respond_success(data, entity=nil, &block)
        response.content_type = Mime::TEXT

        block.call(entity) if block_given?
        render :text => (data.is_a?(Proc) ? data.call(entity) : data)
      end
    end
  end
end