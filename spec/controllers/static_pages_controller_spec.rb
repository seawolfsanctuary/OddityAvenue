# Encoding: utf-8
require "spec_helper"

describe StaticPagesController, type: :controller do
  describe "GET #home" do
    before :each do
      get :home
    end

    it "should exist" do
      expect(response.code).to eq("200")
      expect { get :home }.not_to raise_error # ActionController::RoutingError
    end

    it "should display the Home page" do
      expect(response).to render_template("home")
    end
  end

  describe "GET #about" do
    before :each do
      get :about
    end

    it "should exist" do
      expect(response.code).to eq("200")
      expect { get :about }.not_to raise_error # ActionController::RoutingError
    end

    it "should display the About Me page" do
      expect(response).to render_template("about")
    end
  end

  describe "GET #delivery_info" do
    before :each do
      get :delivery_info
    end

    it "should exist" do
      expect(response.code).to eq("200")
      expect { get :about }.not_to raise_error # ActionController::RoutingError
    end

    it "should display the Delivery Info page" do
      expect(response).to render_template("delivery_info")
    end
  end

  describe "GET #contact" do
    before :each do
      get :contact
    end

    it "should exist" do
      expect(response.code).to eq("200")
      expect { get :contact }.not_to raise_error # ActionController::RoutingError
    end

    it "should display the Contact page" do
      expect(response).to render_template("contact")
    end
  end

  describe "POST #make_contact" do
    before do
      StaticContent.destroy_all
      StaticContent.create(page: "contact", part: "email", body: "test@example.com")
    end

    it "should check for errors" do
      expect(controller).to receive(:contact_errors).once.and_return([])
      post :make_contact, {
        :name => "Mr. Smith", :email => "mr@smith.com",
        :message => "Hello!"
      }
    end

    it "should send the message when there are no errors" do
      expect(controller).to receive(:contact_errors).once.and_return([])
      expect(controller).to receive(:send_message!).once.and_return(true)
      post :make_contact, {
        :name => "Mr. Smith", :email => "mr@smith.com",
        :message => "Hello!"
      }
    end

    it "should not send the message but display the errors when there are errors" do
      expect(controller).to receive(:contact_errors).once.and_return(["No e-mail address"])
      expect(controller).not_to receive(:send_message!)
      expect(ContactMailer).not_to receive(:contact_email)
      post :make_contact, {
        :name => "Mr. Smith", # :email => "mr@smith.com",
        :message => "Hello!"
      }
      expect(flash[:error]).to be_include("No e-mail address")
    end
  end

  describe "#encode_params" do
    it "should replace non-UTF-8 characters with an underscore" do
      raw = { name: "name", email: "", subject: nil, message: "> \xC2 絵文字 ð€" }
      safe = controller.send(:encode_params, raw)
      expect(safe).to eq({ name: "name", email: "", subject: "", message: "> _ 絵文字 ð€" })
    end
  end

  describe "#contact_errors" do
    it "should be private" do
      expect { get :contact_errors }.to raise_error # ActionController::RoutingError
    end

    context "should add an error when any of the fields are blank" do
      before(:each) do
        @p = {:name => "name", :email => "name@domain.tld", :subject => "subject", :message => "message"}
      end

      it "name" do
        @p[:name] = ""
        expect(controller.send(:contact_errors, @p).size).to eq(1)
      end

      it "subject" do
        @p[:subject] = ""
        expect(controller.send(:contact_errors, @p).size).to eq(1)
      end

      it "email (format and presence)" do
        @p[:email] = ""
        expect(controller.send(:contact_errors, @p).size).to eq(2)
      end

      it "email (format)" do
        @p[:email] = "hello"
        expect(controller.send(:contact_errors, @p).size).to eq(1)
      end

      it "message" do
        @p[:message] = ""
        expect(controller.send(:contact_errors, @p).size).to eq(1)
      end
    end
  end

  context "#present_errors" do
    it "should return nil when there are no errors" do
      expect(controller.send(:present_errors)).to be_nil
      expect(controller.send(:present_errors, [])).to be_nil
    end

    it "should present one error in a HTML list" do
      expect(controller.send(:present_errors, ["123"])).to eq("<ul><li>123</li></ul>")
    end

    it "should present more than one error in a HTML list" do
      expect(controller.send(:present_errors, ["123", "456", "789"])).to eq("<ul><li>123</li><li>456</li><li>789</li></ul>")
    end

    it "should escape HTML in the error content" do
      expect(controller.send(:present_errors, ["<p>Boo!</p>"])).to eq("<ul><li>&lt;p&gt;Boo!&lt;/p&gt;</li></ul>")
    end
  end
end
