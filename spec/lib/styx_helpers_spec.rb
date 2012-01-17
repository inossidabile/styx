require 'spec_helper'

describe Styx::Helpers do

  let :controller do
    controller = double('controller')
    controller.class.should_receive(:helper_method).with(:this_page?, :this_namespace?)
    controller.class_eval do
      include Styx::Helpers
    end

    controller
  end

  it '#this_page?' do
    controller.stub(:controller_name => 'tests')
    controller.stub(:action_name => 'index')

    cases = [
      [
        be_true, [
          'tests#index',
          '#index'
        ]
      ], [
        be_false, [
          'fails#index',
          'tests#show',
          '#show'
        ]
      ]
    ]

    cases.each do |group|
      be_ok, examples = group
      examples.each do |example|
        controller.this_page?(example).should be_ok
      end
    end
  end

  it '#this_namespace?' do
    controller.stub(:controller_path => 'module/tests')

    cases = [
      [
        be_true, [
          'module'
        ]
      ], [
        be_false, [
          'whatever'
        ]
      ]
    ]

    cases.each do |group|
      be_ok, examples = group
      examples.each do |example|
        controller.this_namespace?(example).should be_ok
      end
    end
  end
end