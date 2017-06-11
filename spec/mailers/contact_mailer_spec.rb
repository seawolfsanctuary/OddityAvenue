require "spec_helper"

describe ContactMailer, type: :mailer do
  before do
    name = "RSpec Test"
    from = "rspec@test.it"
    subject = "Test Message"
    body = "This is the message body."

    @email = ContactMailer.new.contact_email(body, name, from, subject)
  end

  it "should create an e-mail message mailer" do
    expect(@email).to be_a(SendGridMailer)
  end

  it "should have a sender e-mail address" do
    expect(@email.from).to eq("OddityAvenue E-Mail Robot <webmaster@seawolfsanctuary.com>")
  end

  it "should have the correct subject" do
    expect(@email.subject).to eq("OddityAvenue Contact - Test Message")
  end

  let(:sendgid_mailer) { double(:sendmail_mailer, valid?: true, send!: true) }

  it "should send the e-mail message" do
    expect(SendGridMailer).to receive(:new).and_return(sendgid_mailer)

    name = "RSpec Test"
    from = "rspec@test.it"
    subject = "Test Message"
    body = "This is the message body."

    ContactMailer.new.contact_email(body, name, from, subject)
  end
end
