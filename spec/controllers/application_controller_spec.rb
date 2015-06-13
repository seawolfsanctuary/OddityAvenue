require "spec_helper"

describe ApplicationController do
  describe "#admin" do
    it "should redirect to the login page" do
      get 'admin'
      response.should redirect_to(new_user_session_path)
    end

    it "should have the correct routing" do
      new_user_session_path.should == "/admin/sign_in"
    end
  end

  describe ".active_action?" do
    before do
      controller.stub(:controller_name).and_return("MyController")
      controller.stub(:action_name).and_return("MyAction")
    end

    context "with the action specified" do
      it "should be  true for the   active controller and   active action" do
        controller.should be_active_action("MyController", "MyAction")
      end

      it "should be false for the   active controller and inactive action" do
        controller.should_not be_active_action("MyController", "OtherAction")
      end

      it "should be false for the inactive controller and   active action" do
        controller.should_not be_active_action("OtherController", "MyAction")
      end

      it "should be false for the inactive controller and inactive action" do
        controller.should_not be_active_action("OtherController", "OtherAction")
      end
    end

    context "without the action specified" do
      it "should be  true for the   active controller" do
        controller.should be_active_action("MyController")
      end

      it "should be false for the inactive controller" do
        controller.should_not be_active_action("OtherController")
      end
    end
  end
end