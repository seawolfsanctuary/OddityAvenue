class StaticPagesController < ApplicationController
  def home
    @body_text = StaticContent.load("home", "text")
    raise "Error raised at #{Time.now}" if params["raise_error"]
  end

  def about
    @body_text = StaticContent.load("about", "text")
  end

  def delivery_info
    @body_text = StaticContent.load("delivery_info", "text")
  end

  def contact
    @contact_email = StaticContent.load("contact", "email")
    @body_text = StaticContent.load("contact", "text")
  end

  def make_contact
    safe_params = encode_params(params)
    errors = contact_errors(safe_params)
    if errors.empty?
      send_message! *%w{ message name email subject }.map {|p| safe_params[p].to_s }
      flash["info"] = I18n.t('contact.success')
    else
      flash["error"] = present_errors(errors)
    end

    redirect_to :contact
  end

  private
  
  def encode_params(p)
    safe_params = {}
    p.each do |k, v|
      safe_params[k] = String(v).encode('UTF-8', 'UTF-8', invalid: :replace, replace: '_')
    end
    return safe_params
  end

  def contact_errors(safe_params)
    errors = []
    %w{ name email subject message }.each do |i|
      errors << I18n.t('contact.failures.blank_field' , i: i) if safe_params[i].blank?
    end
    errors << I18n.t('contact.failures.email_invalid') unless safe_params['email'] =~ /(.+)@(.+)\.(.+)/

    return errors
  end

  def present_errors(ary=nil)
    return Array(ary).empty? ? nil : ary.join(" ")
  end

  def send_message!(message, name, email, subject)
    ContactMailer.new.contact_email(message, name, email, subject)
  end
end
