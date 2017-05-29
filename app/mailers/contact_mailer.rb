class ContactMailer < ApplicationMailer
  def contact_email message, name, email, subject
    @env = Rails.configuration.action_mailer.smtp_settings.fetch(:domain) { 'oddityavenue.com' }
    @time = Time.now.strftime("%d/%m/%Y %H:%M")
    @from_name = name.to_s
    @from_email = email.to_s
    @subject = subject.to_s
    @message = message.to_s

    to = StaticContent.load("contact", "email")

    mail(
      :from    => "OddityAvenue E-Mail Robot <webmaster@seawolfsanctuary.com>",
      :to      => to,
      :subject => "OddityAvenue Contact - #{subject}"
    )
  end
end
