require "spec_helper"

describe StaticPagesController do
  describe "GET #home" do
    before :each do
      get :home
    end

    it "should exist" do
      response.code.should == "200"
      lambda { get :home }.should_not raise_error(ActionController::RoutingError)
    end

    it "should display the Home page" do
      response.should render_template("home")
    end
  end

   describe "GET #about" do
    before :each do
      get :about
    end

    it "should exist" do
      response.code.should == "200"
      lambda { get :about }.should_not raise_error(ActionController::RoutingError)
    end

    it "should display the About Me page" do
      response.should render_template("about")
    end
  end

  describe "GET #contact" do
    before :each do
      get :contact
    end

    it "should exist" do
      response.code.should == "200"
      lambda { get :contact }.should_not raise_error(ActionController::RoutingError)
    end

    it "should display the Contact page" do
      response.should render_template("contact")
    end
  end

  describe "POST #make_contact" do
    pending
  end

  describe "GET #validate_contact" do
    it "should be private" do
      lambda { get :validate_contact }.should raise_error(ActionController::RoutingError)
    end
  end
end
