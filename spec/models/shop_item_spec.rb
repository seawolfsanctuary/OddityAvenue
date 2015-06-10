require 'spec_helper'

describe ShopItem do
  context "initialisation" do
    it "should have inherited various attributes" do
      %w{ title description
          image_filename_1 image_filename_2 image_filename_3
          thumbnail_filename categories enabled
      }.each do |a|
        ShopItem.new.should respond_to("#{a}".to_sym)
        ShopItem.new.should respond_to("#{a}=".to_sym)
      end
    end

    it "should have it's own accessible attributes" do
      %w{ quantity price }.each do |a|
        ShopItem.new.should respond_to("#{a}".to_sym)
        ShopItem.new.should respond_to("#{a}=".to_sym)
      end
    end
  end

  context "quantity" do
    before(:all) do
      @i = ShopItem.new
    end

    it "should not be accepted when less than zero" do
      @i.quantity = -1
      @i.save.should be_false
    end

    it "should be accepted when zero" do
      @i.quantity = 0
      @i.save.should be_true
    end

    it "should be accepted when greater than zero" do
      @i.quantity = 1
      @i.save.should be_true
    end
  end

  context "price" do
    before(:all) do
      @i = ShopItem.new
    end

    it "should not be accepted when less than zero" do
      @i.price = -1
      @i.save.should be_false
    end

    it "should be accepted when zero" do
      @i.price = 0
      @i.save.should be_true
    end

    it "should be accepted when greater than zero" do
      @i.price = 1
      @i.save.should be_true
    end
  end

  context "#move" do
    before(:each) do
      PortfolioItem.delete_all
      ShopItem.delete_all
      @i = FactoryGirl.create(:shop_item)
    end

    it "should override Item#move" do
      lambda { @i.move }.should_not raise_error # NoMethodError
    end

    it "should return -1 when the PortfolioItem could not be created" do
      PortfolioItem.any_instance.should_receive(:save).and_return(false)
      @i.move.should == -1
    end

    it "should not attempt to remove the ShopItem when the PortfolioItem could not be created" do
      PortfolioItem.any_instance.should_receive(:save).and_return(false)
      ShopItem.any_instance.should_not_receive(:destroy)
      ShopItem.any_instance.should_not_receive(:delete)
      @i.move
    end

    it "should return  0 when the ShopItem could not be removed" do
      ShopItem.any_instance.should_receive(:destroy).and_return(false)
      @i.move.should == 0
    end

    it "should return  1 when successful" do
      @i.move.should == 1
    end

    it "should create a PortfolioItem" do
      lambda { @i.move }.should change(PortfolioItem, :count).by(1)
    end

    it "should destroy the ShopItem" do
      lambda { @i.move }.should change(ShopItem, :count).by(-1)
    end

    it "should loop through the attributes" do
      @i.move
      PortfolioItem.last.title.should == @i.title
      PortfolioItem.last.description.should == @i.description
    end

    it "should handle source-only attributes" do
      pending "how do we test the begin/rescue?"
      @i.move
    end

    it "should set default destination-only attributes" do
      true ## not applicable
    end
  end

  context "tagged ShopItem lookup" do
    before(:all) do
      @model = ShopItem
    end

    context ".active_taggings" do
      context "when empty" do
        before(:all) do
          tagged_model_delete_all(@model)
        end

        before(:each) do
          Rails.logger.debug "\nStarting test."
        end
        after(:each) do
          Rails.logger.debug "Test finished.\n"
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 3, matching: /^SELECT "(shop_items|taggings|tags)"\.\*/ })
        end

        it "should return every tagging" do
          @model.active_taggings.should be_empty
        end
      end

      context "when one tag contains only active items" do
        before(:all) do
          tagged_model_delete_all(@model)
          2.times do
            item = FactoryGirl.create(:shop_item)
            item.category_list.add("tag_one")
            item.save
          end
        end

        before(:each) do
          Rails.logger.debug "\nStarting test."
        end
        after(:each) do
          Rails.logger.debug "Test finished.\n"
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 3, matching: /^SELECT "(shop_items|taggings|tags)"\.\*/ })
        end

        it "should return one tagging per (two) item" do
          @model.active_taggings.collect(&:class).should == [
            ActsAsTaggableOn::Tagging,
            ActsAsTaggableOn::Tagging
          ]
        end
      end

      context "when one tag contains only inactive items" do
        before(:all) do
          tagged_model_delete_all(@model)
          2.times do
            item = FactoryGirl.create(:shop_item, enabled: false)
            item.category_list.add("tag_one")
            item.save
          end
        end

        before(:each) do
          Rails.logger.debug "\nStarting test."
        end
        after(:each) do
          Rails.logger.debug "Test finished.\n"
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 3, matching: /^SELECT "(shop_items|taggings|tags)"\.\*/ })
        end

        it "should return zero taggings per item" do
          @model.active_taggings.collect(&:class).should == []
        end
      end

      context "when one tag contains some inactive items" do
        before(:all) do
          tagged_model_delete_all(@model)

          one = FactoryGirl.create(:shop_item)
          one.category_list.add("tag_one")
          one.save
          two = FactoryGirl.create(:shop_item, enabled: false)
          two.category_list.add("tag_one")
          two.save
        end

        before(:each) do
          Rails.logger.debug "\nStarting test."
        end
        after(:each) do
          Rails.logger.debug "Test finished.\n"
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 3, matching: /^SELECT "(shop_items|taggings|tags)"\.\*/ })
        end

        it "should return one taggings per (two) item" do
          @model.active_taggings.collect(&:class).should == [
            ActsAsTaggableOn::Tagging
          ]
        end
      end

      context "when multiple tags contain the same items" do
        before(:all) do
          tagged_model_delete_all(@model)

          item = FactoryGirl.create(:shop_item)
          item.category_list.add("tag_one")
          item.category_list.add("tag_two")
          item.category_list.add("tag_three")
          item.save
        end

        before(:each) do
          Rails.logger.debug "\nStarting test."
        end
        after(:each) do
          Rails.logger.debug "Test finished.\n"
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 3, matching: /^SELECT "(shop_items|taggings|tags)"\.\*/ })
        end

        it "should return one taggings per (two) item" do
          @model.active_taggings.collect(&:class).should == [
            ActsAsTaggableOn::Tagging,
            ActsAsTaggableOn::Tagging,
            ActsAsTaggableOn::Tagging
          ]
        end
      end
    end
  end
end
