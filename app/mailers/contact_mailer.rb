class ContactMailer < ActionMailer::Base
  default from: "webmaster@#{Rails.configuration.config.action_mailer.smtp_settings[:domain] || 'oddityavenue.com'}"

  def contact_email message, name, email, subject
    @env = Rails.configuration.config.action_mailer.smtp_settings[:domain] || 'oddityavenue.com'
    @time = Time.now.strftime("%d/%m/%Y %H:%M")
    @message = message.to_s

    mail(
      :from    => "#{name} <#{email}>",
      :to      => 'webmaster@seawolfsanctuary.com',
      :subject => "OddityAvenue Contact - #{subject}"
    )
  end
end
