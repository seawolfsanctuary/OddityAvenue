class Admin::StaticPagesController < ApplicationController
  def edit_home
    @body_text = StaticContent.load("home", "text")
    flash = {}
  end

  def update_home
    body_text = params["content"]
    saved_content = StaticContent.find_by_page_and_part("home", "text")
    if saved_content
      saved_content.body = body_text
      if saved_content.save
        flash[:info] = I18n.t('admin.update_successful', :page => "home")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "home")
      end
    else
      content = StaticContent.new
      content.page = "home"
      content.part = "text"
      content.body = body_text
      if saved_content.save
        flash[:info] = I18n.t('admin.create_successful', :page => "home")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "home")
      end
    end

    @body_text = saved_content.body
    render :edit_home
  end

  def edit_about
    @body_text = StaticContent.load("about", "text")
    flash = {}
  end

  def update_about
    body_text = params["content"]
    saved_content = StaticContent.find_by_page_and_part("about", "text")
    if saved_content
      saved_content.body = body_text
      if saved_content.save
        flash[:info] = I18n.t('admin.update_successful', :page => "about")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "about")
      end
    else
      content = StaticContent.new
      content.page = "about"
      content.part = "text"
      content.body = body_text
      if saved_content.save
        flash[:info] = I18n.t('admin.create_successful', :page => "about")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "about")
      end
    end

    @body_text = saved_content.body
    render :edit_about
  end

  def edit_contact
    @email_address = StaticContent.load("contact", "email")
    @body_text = StaticContent.load("contact", "text")
    flash = {}
  end

  def update_contact
    email_address = params["email"]
    body_text = params["content"]

    saved_email   = StaticContent.find_by_page_and_part("contact", "email")
    saved_content = StaticContent.find_by_page_and_part("contact", "text")

    if saved_email
      saved_email.body = email_address
      if saved_email.save
        flash[:info] = I18n.t('admin.update_successful', :page => "contact e-mail address")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "contact e-mail address")
      end
    else
      email = StaticContent.new
      email.page = "contact"
      email.part = saved_email
      email.body = body_text
      if email.save
        flash[:info] = I18n.t('admin.create_successful', :page => "contact e-mail address")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "contact e-mail address")
      end
    end

     if saved_content
      saved_content.body = body_text
      if saved_content.save
        flash[:info] = I18n.t('admin.update_successful', :page => "contact")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "contact")
      end
    else
      content = StaticContent.new
      content.page = "contact"
      content.part = nil
      content.body = body_text
      if saved_content.save
        flash[:info] = I18n.t('admin.create_successful', :page => "contact")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "contact")
      end
    end

    @email_address = email_address.body
    @body_text = saved_content.body

    render :edit_contact
  end
end
