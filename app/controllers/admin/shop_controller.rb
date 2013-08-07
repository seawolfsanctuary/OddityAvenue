class Admin::ShopController < ApplicationController
  before_filter :authenticate_user!

  def index
    @items = ShopItem.order("id")
    @delivery_opts = StaticContent.load("shop", "delivery_opts")
  end

  def new
    @item = ShopItem.new
  end

  def create
    @item = ShopItem.create(params["shop_item"])

    if @item.save
      flash[:info] = I18n.t('admin.create_successful', :page => "shop item")
      @items = ShopItem.all
      redirect_to admin_shop_index_path
    else
      flash[:error] = I18n.t('admin.create_failed', :page => "shop item")
      redirect_to new_admin_shop_path
    end
  end

  def edit
    @item = ShopItem.find(params["id"])
  end

  def update
    i = ShopItem.find(params["id"])
    if i.update_attributes!(params["shop_item"])
      flash[:info] = I18n.t('admin.update_successful', :page => "shop item")
      @items = ShopItem.all
      redirect_to admin_shop_index_path
    else
      flash[:error] = I18n.t('admin.update_failed', :page => "shop item")
      @item = params["shop_item"]
      redirect_to edit_admin_shop_path(i.id)
    end
  end

  def destroy
    if ShopItem.delete(params["id"])
      flash[:info] = I18n.t('admin.delete_successful', :page => "shop item")
    else
      flash[:error] = I18n.t('admin.delete_failed', :page => "shop item")
    end

    @items = ShopItem.all
    redirect_to admin_shop_index_path
  end

  def update_delivery_opts
    new_opts = params["delivery_opts"]
    content = StaticContent.find_by_page_and_part("shop", "delivery_opts")
    if content
      content.body = new_opts
      if content.save
        flash[:info] = I18n.t('admin.update_successful', :page => "delivery")
      else
        flash[:error] = I18n.t('admin.update_failed', :page => "delivery")
      end
    else
      content = StaticContent.new
      content.page = "shop"
      content.part = "delivery_opts"
      content.body = new_opts
      if content.save
        flash[:info] = I18n.t('admin.create_successful', :page => "delivery")
      else
        flash[:error] = I18n.t('admin.create_failed', :page => "delivery")
      end
    end

    redirect_to admin_shop_index_path
  end
end
