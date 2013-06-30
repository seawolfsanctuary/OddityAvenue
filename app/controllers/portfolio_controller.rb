class PortfolioController < ApplicationController
  def index
    @items = PortfolioItem.all
  end

  def show
    @item = PortfolioItem.find(params[:id])
  end
end
