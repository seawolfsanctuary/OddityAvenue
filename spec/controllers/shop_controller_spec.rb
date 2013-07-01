require 'spec_helper'

describe ShopController do
  context "GET index" do
    it "should load all the ShopItems that are not for sale but are visible" do
      ShopItem.delete_all
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
  end

  context "GET show" do
    it "should load the given ShopItem" do
      item = FactoryGirl.create :shop_item
      get 'show', id: item.id
      assigns[:item].should == item
    end
  end
end
