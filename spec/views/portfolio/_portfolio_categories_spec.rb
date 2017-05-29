require 'spec_helper'

describe 'portfolio/_portfolio_categories' do
  before(:each) do
    PortfolioItem.delete_all
    ActsAsTaggableOn::Tag.delete_all
  end

  context "with no PortfolioItem categories" do
    it "should not create a new list" do
      render
      expect(rendered).not_to be_include("<ul>")
    end
  end

  context "with PortfolioItem categories" do
    before do
      FactoryGirl.create :portfolio_item, category_list: [ "cat 1", "cat 2" ]
      FactoryGirl.create :portfolio_item, category_list: [ "cat 2", "cat 3" ], enabled: false
      @categories = PortfolioItem.tag_names_from_taggings(PortfolioItem.active_taggings)
    end

    it "should create a new list" do
      render
      expect(rendered).to be_include("<ul>")
      expect(rendered).to be_include("</ul>")
    end

    it "should create a new list item for each category where enabled items exist" do
      render
      expect(rendered).to be_include("<li>" + link_to("cat 1", portfolio_item_category_path("cat 1"))  + "</li>")
      expect(rendered).to be_include("<li>" + link_to("cat 2", portfolio_item_category_path("cat 2"))  + "</li>")
    end

   it "should not create a new list item for each category where only disabled items exist" do
      render
      expect(rendered).not_to be_include("cat 3")
    end
  end
end
