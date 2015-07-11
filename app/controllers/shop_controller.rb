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
      taggings  = ShopItem.active_taggings
      @titles   = ShopItem.tag_names_from_taggings(taggings)
      @items    = ShopItem.first_items_from_tags_from_taggings(taggings)
    end
  end

  def show
    @item = ShopItem.find_by_id(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless !@item.nil? && @item.enabled
  end
end
