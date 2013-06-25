require 'spec_helper'

describe PortfolioController do
  context "GET index" do
    before(:all) do
      PortfolioItem.delete_all
      5.times do
        FactoryGirl.create :portfolio_item
      end
    end

    it "should load all the PortfolioItems that are for sale" do
      get :index
      response.status.should == 200
      assigns[:items].collect(&:class).should == [
        PortfolioItem, PortfolioItem,
        PortfolioItem, PortfolioItem,
        PortfolioItem
      ]
    end
  end

  context "GET show" do
    pending "should load the given PortfolioItem"
  end

  context "GET edit" do
    pending "should load the given PortfolioItem"
  end
end
