class Admin::PortfolioController < ApplicationController
  before_filter :authenticate_user!

  def index
    @items = PortfolioItem.order("id")
  end

  def new
    @item = PortfolioItem.new
  end

  def create
    @item = PortfolioItem.create(params["portfolio_item"])

    if @item.save
      flash[:info] = I18n.t('admin.create_successful', :page => "portfolio item")
      @items = PortfolioItem.all
      redirect_to admin_portfolio_index_path
    else
      flash[:error] = I18n.t('admin.create_failed', :page => "portfolio item")
      redirect_to new_admin_portfolio_path
    end
  end

  def edit
    @item = PortfolioItem.find(params["id"])
  end

  def update
    i = PortfolioItem.find(params["id"])
    if i.update_attributes!(params["portfolio_item"])
      flash[:info] = I18n.t('admin.update_successful', :page => "portfolio item")
      @items = PortfolioItem.all
      redirect_to admin_portfolio_index_path
    else
      flash[:error] = I18n.t('admin.update_failed', :page => "portfolio item")
      @item = params["portfolio_item"]
      redirect_to edit_admin_portfolio_path(i.id)
    end
  end

  def destroy
    if PortfolioItem.delete(params["id"])
      flash[:info] = I18n.t('admin.delete_successful', :page => "portfolio item")
    else
      flash[:error] = I18n.t('admin.delete_failed', :page => "portfolio item")
    end

    @items = PortfolioItem.all
    redirect_to admin_portfolio_index_path
  end
end
