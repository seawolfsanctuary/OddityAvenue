require 'spec_helper'

describe PortfolioController do
  context "GET index" do
    it "should load all the PortfolioItems that are visible" do
      PortfolioItem.delete_all
      FactoryGirl.create :portfolio_item
      FactoryGirl.create :portfolio_item, enabled: false
      FactoryGirl.create :portfolio_item
      FactoryGirl.create :portfolio_item, enabled: false
      FactoryGirl.create :portfolio_item

      get :index
      response.status.should == 200
      assigns[:items].collect(&:class).should == [
        PortfolioItem, PortfolioItem,
        PortfolioItem
      ]
    end
  end

  context "GET show" do
    it "should load the given PortfolioItem" do
      item = FactoryGirl.create :portfolio_item
      get 'show', id: item.id
      assigns[:item].should == item
    end
    end
  end
end
