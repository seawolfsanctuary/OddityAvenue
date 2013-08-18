class PortfolioController < ApplicationController
  def index
    if params[:tag]
      @items = PortfolioItem.tagged_with(params[:tag]).where(enabled: true).order("id")
    else
      @items = PortfolioItem.where(enabled: true).order("id")
    end
  end

  def show
    @item = PortfolioItem.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @item.enabled
  end
end
