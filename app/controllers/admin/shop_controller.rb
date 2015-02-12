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
    @item = ShopItem.find_by_id(params["id"])
  end

  def update
    i = ShopItem.find_by_id(params["id"])
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

  def move_to_portfolio
    source = begin
      ShopItem.find_by_id(params[:id])
    rescue ActiveRecord::RecordNotFound
      nil
    end

    if source.present? && source.is_a?(ShopItem)
      case source.move
        when -1 then flash[:error] = "Unable to create portfolio item. Please create and delete manually."
        when  0 then flash[:error] = "Item copied, but unable to delete shop item. Please delete manually."
        when  1 then flash[:info]  = "Item moved successfully."
        else flash[:error] = "Sorry, but something went wrong."
      end
    else
      flash[:error] = "Unable to find that shop item."
    end
    redirect_to admin_shop_index_path
  end
end
