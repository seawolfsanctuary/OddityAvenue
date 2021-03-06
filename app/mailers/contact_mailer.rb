require './lib/send_grid_mailer.rb'

class ContactMailer
  def contact_email message, name, email, subject
    @env = Rails.configuration.action_mailer.smtp_settings.fetch(:domain) { 'oddityavenue.com' }
    @time = Time.now.strftime("%d/%m/%Y %H:%M")
    @from_name = name.to_s
    @from_email = email.to_s
    @subject = subject.to_s
    @message = message.to_s

    to = StaticContent.load("contact", "email")

    mail = ::SendGridMailer.new(
      "webmaster@seawolfsanctuary.com",
      "OddityAvenue E-Mail Robot",
      to,
      "OddityAvenue Contact - #{@subject}",
      message_plain,
      message_html
    )
    mail.send! if mail.valid?

    mail
  end

  private

  def message_html
    template = File.read('./app/views/contact_mailer/contact_email.html.erb')
    return ERB.new(template).result(binding)
  end

  def message_plain
    template = File.read('./app/views/contact_mailer/contact_email.txt.erb')
    return ERB.new(template).result(binding)
  end
end
