require 'spec_helper'

describe ShopController, type: :controller do
  context "GET index" do
    context "when no items exist" do
      before(:each) do
        ShopItem.delete_all
        ActsAsTaggableOn::Tag.delete_all
        @titles = ShopItem.tag_names_from_taggings(ShopItem.active_taggings)
      end

      it "should, when no category is given, show a list of categories" do
        get :index
        expect(response.status).to eq(200)
        expect(assigns[:items]).to eq({})
        expect(response.body).to be_include("Sorry, no items were found.")
      end

      it "should, when a category is given, load all visible ShopItems in that category" do
        get :index, params: { category: "cat 1" }
        expect(response.status).to eq(200)
        expect(assigns[:items]).to eq([])
        expect(response.body).to be_include("Sorry, no items were found in that category.")
      end

      it "not raise any exception when no ShopItems exist, when giving a category" do
        get :index, params: { category: "cat 0" }
        expect(response.status).to eq(200)
        expect(assigns[:items]).to eq([])
        expect(response.body).to be_include("Sorry, no items were found in that category.")
      end

      it "not raise any exception when no ShopItems exist, when not giving a category" do
        get :index
        expect(response.status).to eq(200)
        expect(assigns[:items]).to eq({})
        expect(response.body).to be_include("Sorry, no items were found.")
      end
    end

    context "when categorised items exist" do
      before do
        ShopItem.delete_all
        ActsAsTaggableOn::Tag.delete_all

        FactoryGirl.create :shop_item, title: "One",   category_list: [ "cat 1" ]
        FactoryGirl.create :shop_item, title: "Two",   category_list: [ "cat 1" ], enabled: false
        FactoryGirl.create :shop_item, title: "Three", category_list: [ "cat 1", "cat 2" ]
        FactoryGirl.create :shop_item, title: "Four",  category_list: [ "cat 2" ]
        FactoryGirl.create :shop_item, title: "Five",  category_list: [ "cat 2", "cat 3" ], enabled: false
        @titles = ShopItem.tag_names_from_taggings(ShopItem.active_taggings)
      end

      it "should, when no category is given, show a list of enabled categories" do
        get :index, params: { category: "" }
        expect(response.status).to eq(200)
        expect(response.body).to match(/cat 1(.*)\n(.*)cat 2/)
        expect(response.body).not_to match(/cat 3/)
      end

      it "should, when a category is given, load all visible ShopItems in that category" do
        get :index, params: { category: "cat 1" }
        expect(response.status).to eq(200)
        expect(assigns[:items].collect(&:title)).to eq([
          "One", "Three"
        ])
      end
    end
  end

  context "GET show" do
    before do
      ShopItem.delete_all
      ActsAsTaggableOn::Tag.delete_all
    end

    it "should load the given ShopItem" do
      item = FactoryGirl.create :shop_item
      get 'show', params: { id: item.id }
      expect(assigns[:item]).to eq(item)
    end

    it "should not load the given disabled ShopItem" do
      item = FactoryGirl.create :shop_item, enabled: false
      expect { get 'show', params: { id: item.id } }.to raise_error(ActionController::RoutingError)
    end
  end
end
