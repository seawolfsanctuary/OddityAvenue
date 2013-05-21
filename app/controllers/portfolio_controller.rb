class PortfolioController < ApplicationController
  def index
    @items = []
    5.times { @items << PortfolioItem.new }
  end

  def show
    @item = PortfolioItem.new
  end

  def edit
  end
end
