require 'spec_helper'

describe Admin::StaticPagesController, type: :controller do
  context "when not logged in" do
    describe "GET 'edit_home'" do
      it "should redirect to the login page" do
        get 'edit_home'
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET 'edit_about'" do
      it "should redirect to the login page" do
        get 'edit_about'
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET 'edit_delivery_info'" do
      it "should redirect to the login page" do
        get 'edit_delivery_info'
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET 'edit_contact'" do
      it "should redirect to the login page" do
        get 'edit_contact'
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST 'update_home'" do
      it "should redirect to the login page" do
        post 'update_home'
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST 'update_about'" do
      it "should redirect to the login page" do
        post 'update_about'
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST 'update_delivery_info'" do
      it "should redirect to the login page" do
        post 'update_delivery_info'
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST 'update_contact'" do
      it "should redirect to the login page" do
        post 'update_contact'
        expect(response).to redirect_to new_user_session_path
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
        expect(response).to be_success
        expect(response).to render_template :edit_home
      end

      it "should load the body text" do
        expect(StaticContent).to receive(:load).with("home", "text").once
        get 'edit_home'
      end
    end

    describe "GET 'edit_about'" do
      it "should render the template" do
        get 'edit_about'
        expect(response).to be_success
        expect(response).to render_template :edit_about
      end

      it "should load the body text" do
        expect(StaticContent).to receive(:load).with("about", "text").once
        get 'edit_about'
      end
    end

    describe "GET 'edit_delivery_info'" do
      it "should render the template" do
        get 'edit_delivery_info'
        expect(response).to be_success
        expect(response).to render_template :edit_delivery_info
      end

      it "should load the body text" do
        expect(StaticContent).to receive(:load).with("delivery_info", "text").once
        get 'edit_delivery_info'
      end
    end

    describe "GET 'edit_contact'" do
      it "should render the template" do
        get 'edit_contact'
        expect(response).to be_success
        expect(response).to render_template :edit_contact
      end

      it "should load the body text and e-mail address" do
        expect(StaticContent).to receive(:load).with("contact", "text").once
        expect(StaticContent).to receive(:load).with("contact", "email").once
        get 'edit_contact'
      end
    end

    describe "POST 'update_home'" do
      it "should not redirect to the login page" do
        post 'update_home'
        expect(response).not_to be_redirect
      end

      it "should set a new body text" do
        StaticContent.delete_all
        post 'update_home', { "content" => "New Content" }
        expect(flash[:info]).to eq("Successfully created home content.")
        c = StaticContent.last
        expect(c.page).to eq("home")
        expect(c.part).to eq("text")
        expect(c.body).to eq("New Content")
      end

      it "should update the body text" do
        StaticContent.delete_all
        post 'update_home', { "content" => "New Content" }
        post 'update_home', { "content" => "Newer Content" }
        expect(flash[:info]).to eq("Successfully updated home content.")
        c = StaticContent.last
        expect(c.page).to eq("home")
        expect(c.part).to eq("text")
        expect(c.body).to eq("Newer Content")
      end
    end

    describe "POST 'update_about'" do
      it "should not redirect to the login page" do
        post 'update_about'
        expect(response).not_to be_redirect
      end

      it "should set a new body text" do
        StaticContent.delete_all
        post 'update_about', { "content" => "New Content" }
        expect(flash[:info]).to eq("Successfully created about content.")
        c = StaticContent.last
        expect(c.page).to eq("about")
        expect(c.part).to eq("text")
        expect(c.body).to eq("New Content")
      end

      it "should update the body text" do
        StaticContent.delete_all
        post 'update_about', { "content" => "New Content" }
        post 'update_about', { "content" => "Newer Content" }
        expect(flash[:info]).to eq("Successfully updated about content.")
        c = StaticContent.last
        expect(c.page).to eq("about")
        expect(c.part).to eq("text")
        expect(c.body).to eq("Newer Content")
      end
    end

    describe "POST 'update_delivery_info'" do
      it "should not redirect to the login page" do
        post 'update_delivery_info'
        expect(response).not_to redirect_to new_user_session_path
      end

      it "should set a new body text" do
        StaticContent.delete_all
        post 'update_delivery_info', { "content" => "New Content" }
        expect(flash[:info]).to eq("Successfully created delivery info content.")
        c = StaticContent.last
        expect(c.page).to eq("delivery_info")
        expect(c.part).to eq("text")
        expect(c.body).to eq("New Content")
      end

      it "should update the body text" do
        StaticContent.delete_all
        post 'update_delivery_info', { "content" => "New Content" }
        post 'update_delivery_info', { "content" => "Newer Content" }
        expect(flash[:info]).to eq("Successfully updated delivery info content.")
        c = StaticContent.last
        expect(c.page).to eq("delivery_info")
        expect(c.part).to eq("text")
        expect(c.body).to eq("Newer Content")
      end
    end

    describe "POST 'update_contact'" do
      it "should not redirect to the login page" do
        post 'update_contact'
        expect(response).not_to be_redirect
      end

      it "should set a new body text and email" do
        StaticContent.delete_all
        post 'update_contact', { "email_address" => "user@site.com" , "content" => "New Content" }
        expect(flash[:info]).to eq("Successfully created contact content.")
        c = StaticContent.last
        expect(c.page).to eq("contact")
        expect(c.part).to eq("text")
        expect(c.body).to eq("New Content")
      end

      it "should update the body text and email" do
        StaticContent.delete_all
        post 'update_contact', { "email_address" => "user@site.com" , "content" => "New Content" }
        post 'update_contact', { "email_address" => "newuser@site.com" , "content" => "Newer Content" }
        expect(flash[:info]).to eq("Successfully updated contact content.")
        c = StaticContent.last
        expect(c.page).to eq("contact")
        expect(c.part).to eq("text")
        expect(c.body).to eq("Newer Content")
      end

      it "should show a message about successfully updating both the body text and email" do
        StaticContent.delete_all
        post 'update_contact', { "email_address" => "user@site.com" , "content" => "New Content" }
        post 'update_contact', { "email_address" => "newuser@site.com" , "content" => "Newer Content" }
      end

      context "creation failures" do
        before :each do
          StaticContent.delete_all
          allow(StaticContent).to receive(:save).with(false)
          allow_any_instance_of(StaticContent).to receive(:save).and_return(false)
        end
        after :each do
          allow_any_instance_of(StaticContent).to receive(:save).and_call_original
          allow(StaticContent).to receive(:save).and_call_original
        end

        it "should show a message when either the body text and email" do
          post 'update_contact', { "email_address" => "user" , "content" => "New Content" }
          expect(flash[:error]).to eq("Unable to create contact content.")

          post 'update_contact', { "email_address" => "user@site.com" , "content" => "" }
          expect(flash[:error]).to eq("Unable to create contact content.")
        end

        it "should show a message when both the body text and email" do
          post 'update_contact', { "email_address" => "user" , "content" => "" }
          expect(flash[:error]).to eq("Unable to create contact content.")
        end
      end

      context "updating failures" do
        before :each do
          StaticContent.delete_all
        end

        it "should show a message when either the body text and email" do
          post 'update_contact', { "email_address" => "user@site.com" , "content" => "New Content" }
          expect(flash[:error]).not_to eq("Unable to create contact content.")

          allow(StaticContent).to receive(:save).with(false)
          allow_any_instance_of(StaticContent).to receive(:save).and_return(false)

          post 'update_contact', { "email_address" => "user" , "content" => "New Content" }
          expect(flash[:error]).to eq("Unable to update contact content.")

          post 'update_contact', { "email_address" => "user@site.com" , "content" => "" }
          expect(flash[:error]).to eq("Unable to update contact content.")

          allow_any_instance_of(StaticContent).to receive(:save).and_call_original
          allow(StaticContent).to receive(:save).and_call_original
        end

        it "should show a message when both the body text and email" do
          post 'update_contact', { "email_address" => "user@site.com" , "content" => "New Content" }
          expect(flash[:error]).not_to eq("Unable to create contact content.")

          allow(StaticContent).to receive(:save).with(false)
          allow_any_instance_of(StaticContent).to receive(:save).and_return(false)

          post 'update_contact', { "email_address" => "user" , "content" => "" }
          expect(flash[:error]).to eq("Unable to update contact content.")

          allow_any_instance_of(StaticContent).to receive(:save).and_call_original
          allow(StaticContent).to receive(:save).and_call_original
        end
      end
    end
  end
end
