class PortfolioController < ApplicationController
  def index
    @items = PortfolioItem.all
  end

  def show
    @item = PortfolioItem.new
  end
end
