require "spec_helper"

describe ContactMailer, type: :mailer do
  before do
    name = "RSpec Test"
    from = "rspec@test.it"
    subject = "Test Message"
    body = "This is the message body."

    @email = ContactMailer.contact_email(body, name, from, subject)
  end

  it "should create an e-mail message" do
    expect(@email).to be_a(ActionMailer::MessageDelivery)
    expect(@email).not_to be_multipart
  end

  it "should have a sender e-mail address" do
    expect(@email.from).to eq([ "webmaster@seawolfsanctuary.com" ])
  end

  it "should have the correct subject" do
    expect(@email.subject).to eq("OddityAvenue Contact - Test Message")
  end
end
