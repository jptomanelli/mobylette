require 'spec_helper'

describe HomeController do

  it "should render the index view" do
    get :index
    response.should render_template(:index)
    response.should contain("this is the html view")
  end

  it "should have the Rails Testing request type by default" do
    get :index
    request.user_agent.should == "Rails Testing"
    @controller.send(:is_mobile_request?).should be_false
  end

  it "should have respond to mobile requests" do
    force_mobile_request_agent("Android")
    get :index
    request.user_agent.should == "Android"
    @controller.send(:is_mobile_request?).should be_true
  end

  it "reset_test_request_agent should reset the user_agent to Rails Testing" do
    force_mobile_request_agent("Iphone")
    reset_test_request_agent
    get :index
    request.user_agent.should == "Rails Testing"
  end

  it "should have the mobile mime_type" do
    force_mobile_request_agent
    get :index
    @controller.send(:is_mobile_request?).should be_true
    response.should contain("this is the mobile view")
  end


  it "should render desktop view on non mobile request" do
    reset_test_request_agent
    get :respond_to_test
    response.should render_template(:desktop)
  end

  it "should render mobile view on mobile request" do
    force_mobile_request_agent("Android")
    get :respond_to_test
    response.should render_template(:mobile)
  end

  it "should render mobile view on mobile request when .mobile" do
    get :respond_to_test, :format => "mobile"
    response.should render_template(:mobile)
  end


end
