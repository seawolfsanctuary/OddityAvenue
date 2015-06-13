class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :load_categories_for_portfolio
  before_action :load_categories_for_shop

  def admin
    redirect_to new_user_session_path
  end

  def active_action?(c, a=nil)
    return (controller_name == c) if a.nil?
    return (controller_name == c && action_name == a)
  end
  helper_method :active_action?

  private

  def load_categories_for_portfolio
    if active_action?("portfolio")
      @categories = PortfolioItem.tag_names_from_taggings(PortfolioItem.active_taggings)
    end
  end

  def load_categories_for_shop
    if active_action?("shop")
      @categories = ShopItem.tag_names_from_taggings(ShopItem.active_taggings)
    end
  end
end
