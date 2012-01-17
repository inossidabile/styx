require 'spec_helper'

describe Styx::Initializer do

  let :controller do
    controller = double('controller')
    controller.class.should_receive(:helper_method).with(:styx_initialize, :styx_initialize_with)
    controller.class.stub(:before_filter) do |block|
      controller.instance_eval(&block)
    end
    controller.class_eval do
      include Styx::Initializer
    end
    controller.instance_variable_get('@styx_initialize_with').should == {}

    controller
  end

  it '#styx_initialize_with' do
    controller.styx_initialize_with(:test => 'data')
    controller.instance_variable_get('@styx_initialize_with').should == {:test => 'data'}
  end

  it '#styx_initialize' do
    controller.stub(:controller_path => 'module/tests')
    controller.stub(:action_name => 'index')
    controller.should_receive(:render_to_string).and_return('rendered template')
    result = controller.styx_initialize
    result.should == 'rendered template'
    result.html_safe?.should be_true
  end
end