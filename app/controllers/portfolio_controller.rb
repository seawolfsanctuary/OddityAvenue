class PortfolioController < ApplicationController
  def index
    @items = []
    5.times { @items << PortfolioItem.new }
  end

  def show
  end

  def edit
  end
end
