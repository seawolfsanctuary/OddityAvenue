class PortfolioController < ApplicationController
  def index
    @items = PortfolioItem.where(enabled: true)
  end

  def show
    @item = PortfolioItem.find(params[:id])
  end
end
