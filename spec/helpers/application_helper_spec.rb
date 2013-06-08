require "spec_helper"

describe ApplicationHelper do
  describe ".active_action?" do
    before do
      controller.stub(:controller_name).and_return("MyController")
      controller.stub(:action_name).and_return("MyAction")
    end

    context "with the action specified" do
      it "should be  true for the   active controller and   active action" do
        helper.should be_active_action("MyController", "MyAction")
      end

      it "should be false for the   active controller and inactive action" do
        helper.should_not be_active_action("MyController", "OtherAction")
      end

      it "should be false for the inactive controller and   active action" do
        helper.should_not be_active_action("OtherController", "MyAction")
      end

      it "should be false for the inactive controller and inactive action" do
        helper.should_not be_active_action("OtherController", "OtherAction")
      end
    end

    context "without the action specified" do
      it "should be  true for the   active controller" do
        helper.should be_active_action("MyController")
      end

      it "should be false for the inactive controller" do
        helper.should_not be_active_action("OtherController")
      end
    end
  end
end
