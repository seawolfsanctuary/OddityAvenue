require 'spec_helper'

describe PortfolioController do
  context "GET index" do
    context "when no items exist" do
      before(:each) do
        PortfolioItem.delete_all
        ActsAsTaggableOn::Tag.delete_all
      end

      it "should, when no category is given, show a list of categories" do
        get :index
        response.status.should == 200
        assigns[:items].should == []
        response.body.should be_include("Sorry, no items were found.")
      end

      it "should, when a category is given, load all visible PortfolioItems in that category" do
        get :index, category: "cat 1"
        response.status.should == 200
        assigns[:items].should == []
        response.body.should be_include("Sorry, no items were found in that category.")
      end

      it "not raise any exception when no PortfolioItems exist, when giving a category" do
        get :index, category: "cat 0"
        response.status.should == 200
        assigns[:items].should == []
        response.body.should be_include("Sorry, no items were found in that category.")
      end

      it "not raise any exception when no PortfolioItems exist, when not giving a category" do
        get :index
        response.status.should == 200
        assigns[:items].should == []
        response.body.should be_include("Sorry, no items were found.")
      end
    end

    context "when categorised items exist" do
      before(:all) do
        PortfolioItem.delete_all
        ActsAsTaggableOn::Tag.delete_all

        FactoryGirl.create :portfolio_item, title: "One",   category_list: [ "cat 1" ]
        FactoryGirl.create :portfolio_item, title: "Two",   category_list: [ "cat 1" ], enabled: false
        FactoryGirl.create :portfolio_item, title: "Three", category_list: [ "cat 1", "cat 2" ]
        FactoryGirl.create :portfolio_item, title: "Four",  category_list: [ "cat 2" ]
        FactoryGirl.create :portfolio_item, title: "Five",  category_list: [ "cat 2", "cat 3" ], enabled: false
      end

      it "should, when no category is given, show a list of enabled categories" do
        get :index, category: ""
        response.status.should == 200
        response.body.should =~ /cat 1(.*)\n(.*)cat 2/
        response.body.should_not =~ /cat 3/
      end

      it "should, when a category is given, load all visible PortfolioItems in that category" do
        get :index, category: "cat 1"
        response.status.should == 200
        assigns[:items].collect(&:title).should == [
          "One", "Three"
        ]
      end
    end
  end

  context "GET show" do
    before do
      PortfolioItem.delete_all
      ActsAsTaggableOn::Tag.delete_all
    end

    it "should load the given PortfolioItem" do
      item = FactoryGirl.create :portfolio_item
      get 'show', id: item.id
      assigns[:item].should == item
    end

    it "should not load the given disabled PortfolioItem" do
      item = FactoryGirl.create :portfolio_item, enabled: false
      lambda { get 'show', id: item.id }.should raise_error # ActionController::RoutingError
    end
  end
end
