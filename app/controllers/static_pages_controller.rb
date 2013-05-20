class StaticPagesController < ApplicationController
  def home
    @body_text = StaticContent.load(:home, :text)
  end

  def contact
    @contact_email = StaticContent.load(:contact, :email)
    @body_text = StaticContent.load(:contact, :text)
  end

  def make_contact
    errors = contact_errors
    if errors.empty?
      send_message!
      flash[:info] = I18n.t('contact.success')
    else
      flash[:error] = "<ul>"
      errors.each do |e|
        flash[:error] += "<li>#{e}</li>"
      end
      flash[:error] += "</ul>"
      flash[:error] = flash[:error].html_safe
    end
    redirect_to :contact
  end

  def about
    @body_text = StaticContent.load(:about, :text)
  end

  private

  def contact_errors
    errors = []
    [:name, :email, :subject, :message].each do |i|
      errors << "Please fill in the #{i.to_s} field." if params[i].blank?
    end
    errors << "The e-mail address supplied doesn't look right. It must be like name@domain.tld" unless params[:email] =~ /(.*)@(.*)\.(.*)/

    return errors
  end

  def send_message!
  end
end
