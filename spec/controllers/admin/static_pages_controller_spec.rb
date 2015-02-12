require 'spec_helper'

describe Admin::StaticPagesController do

  context "when not logged in" do
    describe "GET 'edit_home'" do
      it "should redirect to the login page" do
        get 'edit_home'
        response.should redirect_to new_user_session_path
      end
    end

    describe "GET 'edit_about'" do
      it "should redirect to the login page" do
        get 'edit_about'
        response.should redirect_to new_user_session_path
      end
    end

    describe "GET 'edit_delivery_info'" do
      it "should redirect to the login page" do
        get 'edit_delivery_info'
        response.should redirect_to new_user_session_path
      end
    end

    describe "GET 'edit_contact'" do
      it "should redirect to the login page" do
        get 'edit_contact'
        response.should redirect_to new_user_session_path
      end
    end

    describe "POST 'update_home'" do
      it "should redirect to the login page" do
        post 'update_home'
        response.should redirect_to new_user_session_path
      end
    end

    describe "POST 'update_about'" do
      it "should redirect to the login page" do
        post 'update_about'
        response.should redirect_to new_user_session_path
      end
    end

    describe "POST 'update_delivery_info'" do
      it "should redirect to the login page" do
        post 'update_delivery_info'
        response.should redirect_to new_user_session_path
      end
    end

    describe "POST 'update_contact'" do
      it "should redirect to the login page" do
        post 'update_contact'
        response.should redirect_to new_user_session_path
      end
    end
  end

  context "when logged in" do
    before do
      Admin::User.delete_all
      @user = FactoryGirl.create(:admin)
      sign_in @user
    end

    describe "GET 'edit_home'" do
      it "should render the template" do
        get 'edit_home'
        response.should be_success
        response.should render_template :edit_home
      end

      it "should load the body text" do
        StaticContent.should_receive(:load).with("home", "text").once
        get 'edit_home'
      end
    end

    describe "GET 'edit_about'" do
      it "should render the template" do
        get 'edit_about'
        response.should be_success
        response.should render_template :edit_about
      end

      it "should load the body text" do
        StaticContent.should_receive(:load).with("about", "text").once
        get 'edit_about'
      end
    end

    describe "GET 'edit_delivery_info'" do
      it "should render the template" do
        get 'edit_delivery_info'
        response.should be_success
        response.should render_template :edit_delivery_info
      end

      it "should load the body text" do
        StaticContent.should_receive(:load).with("delivery_info", "text").once
        get 'edit_delivery_info'
      end
    end

    describe "GET 'edit_contact'" do
      it "should render the template" do
        get 'edit_contact'
        response.should be_success
        response.should render_template :edit_contact
      end

      it "should load the body text and e-mail address" do
        StaticContent.should_receive(:load).with("contact", "text").once
        StaticContent.should_receive(:load).with("contact", "email").once
        get 'edit_contact'
      end
    end

    describe "POST 'update_home'" do
      it "should not redirect to the login page" do
        post 'update_home'
        response.should_not redirect_to new_user_session_path
      end

      it "should set a new body text" do
        StaticContent.delete_all
        post :update_home, { "content" => "New Content" }
        flash[:info].should == "Successfully created home content."
        c = StaticContent.last
        c.page.should == "home"
        c.part.should == "text"
        c.body.should == "New Content"
      end

      it "should update the body text" do
        StaticContent.delete_all
        post :update_home, { "content" => "New Content" }
        post :update_home, { "content" => "Newer Content" }
        flash[:info].should == "Successfully updated home content."
        c = StaticContent.last
        c.page.should == "home"
        c.part.should == "text"
        c.body.should == "Newer Content"
      end
    end

    describe "POST 'update_about'" do
      it "should not redirect to the login page" do
        post 'update_about'
        response.should_not redirect_to new_user_session_path
      end

      it "should set a new body text" do
        StaticContent.delete_all
        post :update_about, { "content" => "New Content" }
        flash[:info].should == "Successfully created about content."
        c = StaticContent.last
        c.page.should == "about"
        c.part.should == "text"
        c.body.should == "New Content"
      end

      it "should update the body text" do
        StaticContent.delete_all
        post :update_about, { "content" => "New Content" }
        post :update_about, { "content" => "Newer Content" }
        flash[:info].should == "Successfully updated about content."
        c = StaticContent.last
        c.page.should == "about"
        c.part.should == "text"
        c.body.should == "Newer Content"
      end
    end

    describe "POST 'update_delivery_info'" do
      it "should not redirect to the login page" do
        post 'update_delivery_info'
        response.should_not redirect_to new_user_session_path
      end

      it "should set a new body text" do
        StaticContent.delete_all
        post :update_delivery_info, { "content" => "New Content" }
        flash[:info].should == "Successfully created delivery info content."
        c = StaticContent.last
        c.page.should == "delivery_info"
        c.part.should == "text"
        c.body.should == "New Content"
      end

      it "should update the body text" do
        StaticContent.delete_all
        post :update_delivery_info, { "content" => "New Content" }
        post :update_delivery_info, { "content" => "Newer Content" }
        flash[:info].should == "Successfully updated delivery info content."
        c = StaticContent.last
        c.page.should == "delivery_info"
        c.part.should == "text"
        c.body.should == "Newer Content"
      end
    end

    describe "POST 'update_contact'" do
      it "should not redirect to the login page" do
        post 'update_contact'
        response.should_not redirect_to new_user_session_path
      end

      it "should set a new body text and email" do
        StaticContent.delete_all
        post :update_contact, { "email_address" => "user@site.com" , "content" => "New Content" }
        flash[:info].should == "Successfully created contact content."
        c = StaticContent.last
        c.page.should == "contact"
        c.part.should == "text"
        c.body.should == "New Content"
      end

      it "should update the body text and email" do
        StaticContent.delete_all
        post :update_contact, { "email_address" => "user@site.com" , "content" => "New Content" }
        post :update_contact, { "email_address" => "newuser@site.com" , "content" => "Newer Content" }
        flash[:info].should == "Successfully updated contact content."
        c = StaticContent.last
        c.page.should == "contact"
        c.part.should == "text"
        c.body.should == "Newer Content"
      end

      it "should show a message about successfully updating both the body text and email" do
        StaticContent.delete_all
        post :update_contact, { "email_address" => "user@site.com" , "content" => "New Content" }
        post :update_contact, { "email_address" => "newuser@site.com" , "content" => "Newer Content" }
      end

      context "creation failures" do
        before :each do
          StaticContent.delete_all
          StaticContent.stub(:save).with(false)
          StaticContent.any_instance.stub(:save).and_return(false)
        end
        after :each do
          StaticContent.any_instance.unstub(:save)
          StaticContent.unstub(:save)
        end

        it "should show a message when either the body text and email" do
          post :update_contact, { "email_address" => "user" , "content" => "New Content" }
          flash[:error].should == "Unable to create contact content."

          post :update_contact, { "email_address" => "user@site.com" , "content" => "" }
          flash[:error].should == "Unable to create contact content."
        end

        it "should show a message when both the body text and email" do
          post :update_contact, { "email_address" => "user" , "content" => "" }
          flash[:error].should == "Unable to create contact content."
        end
      end

      context "updating failures" do
        before :each do
          StaticContent.delete_all
        end

        it "should show a message when either the body text and email" do
          post :update_contact, { "email_address" => "user@site.com" , "content" => "New Content" }
          flash[:error].should_not == "Unable to create contact content."

          StaticContent.stub(:save).with(false)
          StaticContent.any_instance.stub(:save).and_return(false)

          post :update_contact, { "email_address" => "user" , "content" => "New Content" }
          flash[:error].should == "Unable to update contact content."

          post :update_contact, { "email_address" => "user@site.com" , "content" => "" }
          flash[:error].should == "Unable to update contact content."

          StaticContent.any_instance.unstub(:save)
          StaticContent.unstub(:save)
        end

        it "should show a message when both the body text and email" do
          post :update_contact, { "email_address" => "user@site.com" , "content" => "New Content" }
          flash[:error].should_not == "Unable to create contact content."

          StaticContent.stub(:save).with(false)
          StaticContent.any_instance.stub(:save).and_return(false)

          post :update_contact, { "email_address" => "user" , "content" => "" }
          flash[:error].should == "Unable to update contact content."

          StaticContent.any_instance.unstub(:save)
          StaticContent.unstub(:save)
        end
      end
    end
  end
end
