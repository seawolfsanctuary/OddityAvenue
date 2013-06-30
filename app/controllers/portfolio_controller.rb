class PortfolioController < ApplicationController
  def index
    @items = PortfolioItem.where(for_sale: false, hidden: false)
  end

  def show
    @item = PortfolioItem.find(params[:id])
  end
end
