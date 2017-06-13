require 'sendgrid-ruby'

class SendGridMailer
  attr_reader :valid, :from_name, :from_email, :to, :subject, :body_plain, :body_html,
              :response_code, :response_body, :response_headers

  def initialize(from_email, from_name, to, subject, body_plain, body_html)
    @from_email, @from_name, @to, @subject, @body_plain, @body_html =
      from_email, from_name, to, subject, body_plain, body_html
    validate
  end

  def valid?
    @valid == true
  end

  def send!
    mail_obj = build_mail_obj
    Rails.logger.info "Sending email: #{mail_obj.pretty_inspect}"

    results = call_api(mail_obj)
    Rails.logger.error "SendGrid response:\n#{results.pretty_inspect}" unless success?
    results
  end

  def success?
    @response_code == 200
  end

  private

  def validate
    @valid = true
    [ @from_email, @to, @subject, @body_plain ].map do |attr|
      @valid = false if attr.to_s.blank?
    end
  end

  def build_mail_obj
    obj         = SendGrid::Mail.new
    obj.from    = SendGrid::Email.new(email: @from_email, name: @from_name)
    obj.subject = @subject

    personalization = SendGrid::Personalization.new
    personalization.add_to SendGrid::Email.new(email: @to, name: @to)
    obj.add_personalization personalization

    obj.add_content SendGrid::Content.new(type: 'text/plain', value: @body_plain)
    obj.add_content SendGrid::Content.new(type: 'text/html',  value: @body_html)
    obj
  end

  def call_api(mail)
    api = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'] || 'NO_API_KEY_SET')
    response = api.client.mail._('send').post(request_body: mail.to_json)
    @response_code, @response_headers, @response_body =
      response.status_code, response.headers, response.body
    return {
      success?: success?,
      response_code: @response_code,
      response_headers: @response_headers,
      response_body: @response_body
    }
  end
end
