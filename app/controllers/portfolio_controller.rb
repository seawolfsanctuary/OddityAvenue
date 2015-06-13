class PortfolioController < ApplicationController
  def index
    if params[:category]
      @items  = []
      @titles = []
      PortfolioItem.tagged_with(params[:category]).where(enabled: true).order("id").each do |i|
        @items  << i
        @titles << i.title
      end
    else
      taggings  = PortfolioItem.active_taggings
      @titles   = PortfolioItem.tag_names_from_taggings(taggings)
      @items    = PortfolioItem.first_items_from_tags_from_taggings(taggings)
    end
  end

  def show
    @item = PortfolioItem.find_by_id(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless !@item.nil? && @item.enabled
  end
end
