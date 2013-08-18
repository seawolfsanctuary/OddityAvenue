class ShopController < ApplicationController
  def index
    @delivery_opts = StaticContent.load("shop", "delivery_opts")

    if params[:category]
      @items = ShopItem.tagged_with(params[:category]).where(enabled: true).order("id")
    else
      @items = ShopItem.where(enabled: true).order("id")
    end
  end

  def show
    @item = ShopItem.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @item.enabled
  end
end
