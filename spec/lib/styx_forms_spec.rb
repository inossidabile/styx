require 'spec_helper'

describe Styx::Forms do

  let :controller do
    controller = double('controller')
    controller.class_eval do
      include Styx::Forms
    end
    controller.stub(:response => double('response'))
    controller.response.should_receive(:content_type=).with(Mime::TEXT).at_least(:once)

    controller
  end

  context '#styx_form_store_and_respond' do

    it 'respond success' do
      entity = double('model')
      entity.stub(:save => true)
      controller.should_receive(:styx_form_respond_success).with(data = Object.new, entity)
      controller.styx_form_store_and_respond(entity, data) do |e|
        e.should === entity
        # whatever
      end
    end

    it 'respond failure' do
      entity = double('model')
      entity.stub(:save => false)
      entity.stub(:errors => double('errors'))
      entity.errors.stub(:messages => {:field => ["can't this'", "can't that'"]})
      controller.should_receive(:styx_form_respond_failure).with(entity.class.name, entity.errors.messages)
      controller.styx_form_store_and_respond(entity)
    end
  end

  it 'respond success' do
    entity = Object.new
    [
      'data',
      lambda {|e| e.should === entity; 'data' }
    ].each do |data|
      controller.should_receive(:render).with(:text => 'data')
      controller.styx_form_respond_success(data, entity) do |e|
        e.should === entity
        # whatever
      end
    end
  end

  it 'respond failure' do

    errors_cases = [
      {:field => ["can't this'", "can't that'"]},
      ['field1', 'field2']
    ]

    def normalize(errors)
      errors.is_a?(Array) && Hash[*errors.map {|x| [x, nil]}.flatten] || errors
    end

    errors_cases.each do |errors|
      json = {:entity => 'm_cl_name', :messages => normalize(errors)}.to_json
      controller.should_receive(:render).with(:text => json, :status => :unprocessable_entity)
      controller.styx_form_respond_failure('M::ClName', errors)
    end
  end
end