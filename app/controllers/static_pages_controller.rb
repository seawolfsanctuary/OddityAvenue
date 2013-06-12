class StaticPagesController < ApplicationController
  def home
    @body_text = StaticContent.load("home", "text")
  end

  def about
    @body_text = StaticContent.load("about", "text")
  end

  def contact
    @contact_email = StaticContent.load("contact", "email")
    @body_text = StaticContent.load("contact", "text")
  end

  def make_contact
    errors = contact_errors(params)
    if errors.empty?
      send_message! params[:message].to_s, params[:name].to_s, params[:email].to_s, params[:subject].to_s
      flash[:info] = I18n.t('contact.success')
    else
      flash[:error] = errors
    end
    redirect_to :contact
  end

  private

  def contact_errors(p)
    errors = []
    [:name, :email, :subject, :message].each do |i|
      errors << "Please fill in the #{i.to_s} field." if p[i].blank?
    end
    errors << "The e-mail address supplied doesn't look right. It must be like name@domain.tld" unless p[:email] =~ /(.*)@(.*)\.(.*)/

    return errors
  end

  def send_message! message, name, email, subject
    ContactMailer.contact_email(message, name, email, subject).deliver
  end
end
