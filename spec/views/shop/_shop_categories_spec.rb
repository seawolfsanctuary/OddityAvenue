require 'spec_helper'

describe 'shop/_shop_categories' do
  before(:each) do
    ShopItem.delete_all
    ActsAsTaggableOn::Tag.delete_all
  end

  context "with no ShopItem categories" do
    it "should not create a new list" do
      render
      rendered.should_not be_include("<ul>")
    end
  end

  context "with ShopItem categories" do
    before do
      FactoryGirl.create :shop_item, category_list: [ "cat 1", "cat 2" ], enabled: false
    end

    it "should create a new list" do
      render
      rendered.should be_include("<ul>")
      rendered.should be_include("</ul>")
    end

    it "should create a new list item for each category" do
      render
      rendered.should be_include("<li>" + link_to("cat 1", shop_item_category_path(URI::escape("cat 1")))  + "</li>")
      rendered.should be_include("<li>" + link_to("cat 2", shop_item_category_path(URI::escape("cat 2")))  + "</li>")
    end
  end
end
