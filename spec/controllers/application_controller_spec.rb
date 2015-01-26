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
end
