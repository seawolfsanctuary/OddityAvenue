class Admin::PortfolioController < ApplicationController
  before_filter :authenticate_user!

  def index
    @items = PortfolioItem.order("id")
  end

  def new
    @item = PortfolioItem.new
  end

  def create
    @item = PortfolioItem.create(portfolio_item_params)

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
    @item = PortfolioItem.find_by_id(params[:id])
  end

  def update
    i = PortfolioItem.find_by_id(params[:id])
    if i.update_attributes!(portfolio_item_params)
      flash[:info] = I18n.t('admin.update_successful', :page => "portfolio item")
      @items = PortfolioItem.all
      redirect_to admin_portfolio_index_path
    else
      flash[:error] = I18n.t('admin.update_failed', :page => "portfolio item")
      @item = params[:portfolio_item]
      redirect_to edit_admin_portfolio_path(i.id)
    end
  end

  def destroy
    if PortfolioItem.delete(params[:id])
      flash[:info] = I18n.t('admin.delete_successful', :page => "portfolio item")
    else
      flash[:error] = I18n.t('admin.delete_failed', :page => "portfolio item")
    end

    @items = PortfolioItem.all
    redirect_to admin_portfolio_index_path
  end

  def move_to_shop
    source = begin
      PortfolioItem.find_by_id(params[:id])
    rescue ActiveRecord::RecordNotFound
      nil
    end

    if source.present? && source.is_a?(PortfolioItem)
      case source.move
        when -1 then flash[:error] = "Unable to create shop item. Please create and delete manually."
        when  0 then flash[:error] = "Item copied, but unable to delete portfolio item. Please delete manually."
        when  1 then flash[:info]  = "Item moved successfully."
        else flash[:error] = "Sorry, but something went wrong."
      end
    else
      flash[:error] = "Unable to find that portfolio item."
    end
    redirect_to admin_portfolio_index_path
  end

  private

  # Using a private method to encapsulate the permissible parameters
  # is just a good pattern since you'll be able to reuse the same
  # permit list between create and update. Also, you can specialize
  # this method with per-user checking of permissible attributes.
  def portfolio_item_params
    params.require(:portfolio_item).permit(
        :title, :description,
        :image_filename_1, :image_filename_2, :image_filename_3,
        :thumbnail_filename, :category_list, :enabled
    )
  end
end
