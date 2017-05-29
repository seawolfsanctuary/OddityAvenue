require "spec_helper"

describe ApplicationController, type: :controller do
  describe "#admin" do
    it "should redirect to the login page" do
      get 'admin'
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should have the correct routing" do
      expect(new_user_session_path).to eq("/admin/sign_in")
    end
  end

  describe ".active_action?" do
    before do
      allow(controller).to receive(:controller_name).and_return("MyController")
      allow(controller).to receive(:action_name).and_return("MyAction")
    end

    context "with the action specified" do
      it "should be  true for the   active controller and   active action" do
        expect(controller).to be_active_action("MyController", "MyAction")
      end

      it "should be false for the   active controller and inactive action" do
        expect(controller).not_to be_active_action("MyController", "OtherAction")
      end

      it "should be false for the inactive controller and   active action" do
        expect(controller).not_to be_active_action("OtherController", "MyAction")
      end

      it "should be false for the inactive controller and inactive action" do
        expect(controller).not_to be_active_action("OtherController", "OtherAction")
      end
    end

    context "without the action specified" do
      it "should be  true for the   active controller" do
        expect(controller).to be_active_action("MyController")
      end

      it "should be false for the inactive controller" do
        expect(controller).not_to be_active_action("OtherController")
      end
    end
  end
end