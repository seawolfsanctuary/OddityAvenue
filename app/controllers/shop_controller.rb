class ShopController < ApplicationController
  def index
    if params[:category]
      @items  = []
      @titles = []
      ShopItem.tagged_with(params[:category]).where(enabled: true).order("id").each do |i|
        @items  << i
        @titles << i.title
      end
    else
      @items =  []
      @titles = []
      ShopItem.category_counts.each do |c|
        @items  << ShopItem.tagged_with(c.name).select(&:enabled).first
        @titles << c
      end
    end
  end

  def show
    @item = ShopItem.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @item.enabled
  end
end
