class ShopController < ApplicationController
  def index
    @items = ShopItem.where(enabled: true)
  end

  def show
    @item = ShopItem.find(params[:id])
  end
end
