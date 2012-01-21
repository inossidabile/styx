require 'spec_helper'

describe TestsController do
  render_views

  it 'index' do
    get :index
    response.body.should have_content('Styx.Initializers.Tests.initialize({"data":"test"})')
    response.body.should have_content('Styx.Initializers.Tests[\'index\']({"data":"test"})')
  end
end