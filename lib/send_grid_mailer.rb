require 'sendgrid-ruby'

class SendGridMailer
  attr_reader :valid, :from, :to, :subject, :body,
              :response_code, :response_body, :response_headers

  def initialize(from, to, subject, body)
    @from, @to, @subject, @body = from, to, subject, body
    validate
  end

  def valid?
    @valid == true
  end

  def send!
    mail_obj = build_mail_obj
    call_api(mail_obj)
  end

  def success?
    @response_code == 200
  end

  private

  def validate
    @valid = true
    [ @from, @to, @subject, @body ].map do |attr|
      @valid = false if attr.to_s.blank?
    end
  end

  def build_mail_obj
    SendGrid::Mail.new(
      SendGrid::Email.new(email: @from),
      @subject,
      SendGrid::Email.new(email: @to),
      SendGrid::Content.new(type: 'text/plain', value: @body)
    )
  end

  def call_api(mail)
    api = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'] || 'NO_API_KEY_SET')
    response = api.client.mail._('send').post(request_body: mail.to_json)
    @response_code, @response_headers, @response_body =
      response.status_code, response.headers, response.body
    return success?
  end
end
