require 'spec_helper'

describe ShopController do
  context "GET index" do
    before(:each) do
      ShopItem.delete_all
      ActsAsTaggableOn::Tag.delete_all
    end

    it "should load all the ShopItems that are not for sale but are visible" do
      5.times do
        FactoryGirl.create :shop_item
      end

      get :index
      response.status.should == 200
      assigns[:items].collect(&:class).should == [
        ShopItem, ShopItem,
        ShopItem, ShopItem,
        ShopItem
      ]
    end

    it "should load all the ShopItems that are visible and have the given category" do
      FactoryGirl.create :shop_item, category_list: [ "cat 1", "cat 2" ]
      FactoryGirl.create :shop_item, category_list: [ "cat 1", "cat 2" ], enabled: false
      FactoryGirl.create :shop_item, category_list: [ "cat 1" ]
      FactoryGirl.create :shop_item, category_list: [ "cat 1" ], enabled: false
      FactoryGirl.create :shop_item

      get :index, category: "cat 1"
      response.status.should == 200
      assigns[:items].collect(&:class).should == [
        ShopItem, ShopItem
      ]
    end

    it "not raise any exception when no ShopItems exist" do
      get :index
      response.status.should == 200
      assigns[:items].should == []
      response.body.should be_include("Sorry, no items were found in that category.")
    end

    it "not raise any exception when no ShopItems exist that have the given category" do
      FactoryGirl.create :shop_item, category_list: [ "cat 1" ]

      get :index, category: "cat 0"
      response.status.should == 200
      assigns[:items].should == []
      response.body.should be_include("Sorry, no items were found in that category.")
    end
  end

  context "GET show" do
    before(:each) do
      ShopItem.delete_all
    end

    it "should load the given ShopItem" do
      item = FactoryGirl.create :shop_item
      get 'show', id: item.id
      assigns[:item].should == item
    end

    it "should not load the given disabled ShopItem" do
      item = FactoryGirl.create :shop_item, enabled: false
      lambda { get 'show', id: item.id }.should raise_error(ActionController::RoutingError)
    end
  end
end
