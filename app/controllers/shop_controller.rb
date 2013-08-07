class ShopController < ApplicationController
  def index
    @items = ShopItem.where(enabled: true).order("id")
    @delivery_opts = StaticContent.load("shop", "delivery_opts")
  end

  def show
    @item = ShopItem.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @item.enabled
  end
end
