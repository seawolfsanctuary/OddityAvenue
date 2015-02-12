class Admin::StaticPagesController < ApplicationController
  before_filter :authenticate_user!

  def edit_home
    @body_text = StaticContent.load("home", "text")
  end

  def update_home
    body_text = params["content"]
    content = StaticContent.find_by_page_and_part("home", "text")
    if content
      content.body = body_text
      if content.save
        flash[:info] = I18n.t('admin.update_successful', :page => "home")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "home")
      end
    else
      content = StaticContent.new
      content.page = "home"
      content.part = "text"
      content.body = body_text
      if content.save
        flash[:info] = I18n.t('admin.create_successful', :page => "home")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "home")
      end
    end

    @body_text = content.body
    render :edit_home
  end

  def edit_about
    @body_text = StaticContent.load("about", "text")
  end

  def update_about
    body_text = params["content"]
    content = StaticContent.find_by_page_and_part("about", "text")
    if content
      content.body = body_text
      if content.save
        flash[:info] = I18n.t('admin.update_successful', :page => "about")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "about")
      end
    else
      content = StaticContent.new
      content.page = "about"
      content.part = "text"
      content.body = body_text
      if content.save
        flash[:info] = I18n.t('admin.create_successful', :page => "about")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "about")
      end
    end

    @body_text = content.body
    render :edit_about
  end

  def edit_delivery_info
    @body_text = StaticContent.load("delivery_info", "text")
  end

  def update_delivery_info
    body_text = params["content"]
    content = StaticContent.find_by_page_and_part("delivery_info", "text")
    if content
      content.body = body_text
      if content.save
        flash[:info] = I18n.t('admin.update_successful', :page => "delivery info")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "delivery info")
      end
    else
      content = StaticContent.new
      content.page = "delivery_info"
      content.part = "text"
      content.body = body_text
      if content.save
        flash[:info] = I18n.t('admin.create_successful', :page => "delivery info")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "delivery info")
      end
    end

    @body_text = content.body
    render :edit_delivery_info
  end

  def edit_contact
    @email_address = StaticContent.load("contact", "email")
    @body_text = StaticContent.load("contact", "text")
  end

  def update_contact
    email_address = params["email_address"]
    body_text = params["content"]

    email   = StaticContent.find_by_page_and_part("contact", "email")
    content = StaticContent.find_by_page_and_part("contact", "text")

    if email
      email.body = email_address
      if email.save
        flash[:info] = I18n.t('admin.update_successful', :page => "contact e-mail address")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "contact e-mail address")
      end
    else
      email = StaticContent.new
      email.page = "contact"
      email.part = "email"
      email.body = email_address
      if email.save
        flash[:info] = I18n.t('admin.create_successful', :page => "contact e-mail address")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "contact e-mail address")
      end
    end

    if content
      content.body = body_text
      if content.save
        flash[:info] = I18n.t('admin.update_successful', :page => "contact")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "contact")
      end
    else
      content = StaticContent.new
      content.page = "contact"
      content.part = "text"
      content.body = body_text
      if content.save
        flash[:info] = I18n.t('admin.create_successful', :page => "contact")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "contact")
      end
    end

    @email_address = email.body
    @body_text = content.body

    render :edit_contact
  end
end
