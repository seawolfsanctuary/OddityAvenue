class ShopController < ApplicationController
  def index
    @delivery_opts = StaticContent.load("shop", "delivery_opts")

    if params[:category]
      @items  = []
      @titles = []
      ShopItem.tagged_with(params[:category]).where(enabled: true).order("id").each do |i|
        @items  << i
        @titles << i.title
      end
    else
      taggings  = ShopItem.active_taggings
      @titles   = ShopItem.tag_names_from_active_taggings(taggings)
      @items    = ShopItem.one_item_for_active_taggings(taggings)
    end
  end

  def show
    @item = ShopItem.find_by_id(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless !@item.nil? && @item.enabled
  end
end
