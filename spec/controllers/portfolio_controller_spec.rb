require 'spec_helper'

describe PortfolioController do
  context "GET index" do
    before(:each) do
      PortfolioItem.delete_all
      ActsAsTaggableOn::Tag.delete_all
    end

    it "should load all the PortfolioItems that are visible" do
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

    it "should load all the PortfolioItems that are visible and have the given category" do
      FactoryGirl.create :portfolio_item, category_list: [ "cat 1", "cat 2" ]
      FactoryGirl.create :portfolio_item, category_list: [ "cat 1", "cat 2" ], enabled: false
      FactoryGirl.create :portfolio_item, category_list: [ "cat 1" ]
      FactoryGirl.create :portfolio_item, category_list: [ "cat 1" ], enabled: false
      FactoryGirl.create :portfolio_item

      get :index, category: "cat 1"
      response.status.should == 200
      assigns[:items].collect(&:class).should == [
        PortfolioItem, PortfolioItem,
      ]
    end

    it "not raise any exception when no PortfolioItems exist" do
      get :index
      response.status.should == 200
      assigns[:items].should == []
      response.body.should be_include("Sorry, no items were found in that category.")
    end

    it "not raise any exception when no PortfolioItems exist that have the given category" do
      FactoryGirl.create :portfolio_item, category_list: [ "cat 1" ]

      get :index, category: "cat 0"
      response.status.should == 200
      assigns[:items].should == []
      response.body.should be_include("Sorry, no items were found in that category.")
    end
  end

  context "GET show" do
    before(:each) do
      PortfolioItem.delete_all
    end

    it "should load the given PortfolioItem" do
      item = FactoryGirl.create :portfolio_item
      get 'show', id: item.id
      assigns[:item].should == item
    end

    it "should not load the given disabled PortfolioItem" do
      item = FactoryGirl.create :portfolio_item, enabled: false
      lambda { get 'show', id: item.id }.should raise_error(ActionController::RoutingError)
    end
  end
end
