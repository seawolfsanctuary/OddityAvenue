require 'spec_helper'

describe PortfolioController do
  context "GET index" do
    it "should load all the PortfolioItems that are not for sale but are visible" do
      PortfolioItem.delete_all
      FactoryGirl.create :portfolio_item, title: "Item 1", for_sale:  true, hidden: false
      FactoryGirl.create :portfolio_item, title: "Item 2", for_sale:  true, hidden: true
      FactoryGirl.create :portfolio_item, title: "Item 3", for_sale: false, hidden: false
      FactoryGirl.create :portfolio_item, title: "Item 4", for_sale: false, hidden: true
      FactoryGirl.create :portfolio_item, title: "Item 5", for_sale: false, hidden: false

      get :index
      response.status.should == 200
      assigns[:items].collect(&:class).should == [ PortfolioItem, PortfolioItem ]
      assigns[:items].collect(&:title).should == [ "Item 3", "Item 5" ]
    end
  end

  context "GET show" do
    it "should load the given PortfolioItem" do
      @item = FactoryGirl.create :portfolio_item
      get 'show', id: @item.id
      assigns[:item].should == @item
    end
  end
end
