require "spec_helper"

describe ContactMailer do
  before do
    name = "RSpec Test"
    from = "rspec@test.it"
    subject = "Test Message"
    body = "This is the message body."

    @email = ContactMailer.contact_email(body, name, from, subject)
  end

  it "should create an e-mail message" do
    @email.should be_a(Mail::Message)
    @email.should_not be_multipart
  end

  it "should have a sender e-mail address" do
    @email.from.should == "webmaster@seawolfsanctuary.com"
  end

  it "should have the correct subject" do
    @email.subject.should == "OddityAvenue Contact - Test Message"
  end
end
