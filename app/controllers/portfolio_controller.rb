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
      @items =  []
      @titles = []
      PortfolioItem.where(enabled: true).collect(&:categories).reject(&:blank?).flatten.collect(&:name).sort.uniq.each do |c|
        @items  << PortfolioItem.tagged_with(c).where(enabled: true).order("id").first
        @titles << c
      end
    end
  end

  def show
    @item = PortfolioItem.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @item.enabled
  end
end
