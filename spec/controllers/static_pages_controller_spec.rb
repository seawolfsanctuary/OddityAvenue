require "spec_helper"

describe StaticPagesController do
  describe "GET #home" do
    before :each do
      get :home
    end

    it "should exist" do
      response.code.should == "200"
      lambda { get :home }.should_not raise_error # ActionController::RoutingError
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
      lambda { get :about }.should_not raise_error # ActionController::RoutingError
    end

    it "should display the About Me page" do
      response.should render_template("about")
    end
  end

  describe "GET #delivery_info" do
    before :each do
      get :delivery_info
    end

    it "should exist" do
      response.code.should == "200"
      lambda { get :about }.should_not raise_error # ActionController::RoutingError
    end

    it "should display the Delivery Info page" do
      response.should render_template("delivery_info")
    end
  end

  describe "GET #contact" do
    before :each do
      get :contact
    end

    it "should exist" do
      response.code.should == "200"
      lambda { get :contact }.should_not raise_error # ActionController::RoutingError
    end

    it "should display the Contact page" do
      response.should render_template("contact")
    end
  end

  describe "POST #make_contact" do
    before do
      StaticContent.destroy_all
      StaticContent.create(page: "contact", part: "email", body: "test@example.com")
    end

    it "should check for errors" do
      controller.should_receive(:contact_errors).once.and_return([])
      post :make_contact, {
        :name => "Mr. Smith", :email => "mr@smith.com",
        :message => "Hello!"
      }
    end

    it "should send the message when there are no errors" do
      controller.should_receive(:contact_errors).once.and_return([])
      controller.should_receive(:send_message!).once.and_return(true)
      post :make_contact, {
        :name => "Mr. Smith", :email => "mr@smith.com",
        :message => "Hello!"
      }
    end

    it "should not send the message but display the errors when there are errors" do
      controller.should_receive(:contact_errors).once.and_return(["No e-mail address"])
      controller.should_not_receive(:send_message!)
      ContactMailer.should_not_receive(:contact_email)
      post :make_contact, {
        :name => "Mr. Smith", # :email => "mr@smith.com",
        :message => "Hello!"
      }
      flash[:error].should be_include("No e-mail address")
    end
  end

  describe "#contact_errors" do
    it "should be private" do
      lambda { get :contact_errors }.should raise_error # ActionController::RoutingError
    end

    context "should add an error when any of the fields are blank" do
      before(:each) do
        @p = {:name => "name", :email => "name@domain.tld", :subject => "subject", :message => "message"}
      end

      it "name" do
        @p[:name] = ""
        controller.send(:contact_errors, @p).should have(1).item
      end

      it "subject" do
        @p[:subject] = ""
        controller.send(:contact_errors, @p).should have(1).item
      end

      it "email (format and presence)" do
        @p[:email] = ""
        controller.send(:contact_errors, @p).should have(2).items
      end

      it "email (format)" do
        @p[:email] = "hello"
        controller.send(:contact_errors, @p).should have(1).item
      end

      it "message" do
        @p[:message] = ""
        controller.send(:contact_errors, @p).should have(1).item
      end
    end
  end

  context "#present_errors" do
    it "should return nil when there are no errors" do
      controller.send(:present_errors).should be_nil
      controller.send(:present_errors, []).should be_nil
    end

    it "should present one error in a HTML list" do
      controller.send(:present_errors, ["123"]).should == "<ul><li>123</li></ul>"
    end

    it "should present more than one error in a HTML list" do
      controller.send(:present_errors, ["123", "456", "789"]).should == "<ul><li>123</li><li>456</li><li>789</li></ul>"
    end

    it "should escape HTML in the error content" do
      controller.send(:present_errors, ["<p>Boo!</p>"]).should == "<ul><li>&lt;p&gt;Boo!&lt;/p&gt;</li></ul>"
    end
  end
end
