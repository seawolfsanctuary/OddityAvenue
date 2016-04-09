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
    before do
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
    before do
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
      @i.should_receive(:attributes).and_return({"sourceOnlyAttr" => "Hello"})
      ShopItem.new.should_not be_respond_to(:sourceOnlyAttr=)
      lambda { @i.move }.should_not raise_exception
    end

    it "should set default destination-only attributes" do
      true ## not applicable
    end
  end

  context "tagged lookup" do
    before do
      @model = ShopItem
      @model_sym = @model.name.underscore.to_sym
    end

    context ".active_taggings" do
      context "when empty" do
        before do
          tagged_model_delete_all(@model)
        end

        it "should hit the database only once for Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 1..3, matching: /^SELECT "(#{@model.table_name}|taggings|tags)"\.\*/ })
        end

        it "should return every tagging" do
          @model.active_taggings.should be_empty
        end
      end

      context "when one tag contains only active items" do
        before do
          tagged_model_delete_all(@model)
          2.times do
            item = FactoryGirl.create(@model_sym)
            item.category_list.add("tag_one")
            item.save
          end
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 1..3, matching: /^SELECT "(#{@model.table_name}|taggings|tags)"\.\*/ })
        end

        it "should return one tagging per (two) item" do
          @model.active_taggings.collect(&:class).should == [
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging
          ]
        end
      end

      context "when one tag contains only inactive items" do
        before do
          tagged_model_delete_all(@model)
          2.times do
            item = FactoryGirl.create(@model_sym, enabled: false)
            item.category_list.add("tag_one")
            item.save
          end
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 1..3, matching: /^SELECT "(#{@model.table_name}|taggings|tags)"\.\*/ })
        end

        it "should return zero taggings per item" do
          @model.active_taggings.collect(&:class).should == []
        end
      end

      context "when one tag contains some inactive items" do
        before do
          tagged_model_delete_all(@model)

          one = FactoryGirl.create(@model_sym)
          one.category_list.add("tag_one")
          one.save
          two = FactoryGirl.create(@model_sym, enabled: false)
          two.category_list.add("tag_one")
          two.save
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 1..3, matching: /^SELECT "(#{@model.table_name}|taggings|tags)"\.\*/ })
        end

        it "should return one taggings per (two) item" do
          @model.active_taggings.collect(&:class).should == [
              ActsAsTaggableOn::Tagging
          ]
        end
      end

      context "when multiple tags contain the same items" do
        before do
          tagged_model_delete_all(@model)

          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.category_list.add("tag_two")
          item.category_list.add("tag_three")
          item.save
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
             count: 1..3, matching: /^SELECT "(#{@model.table_name}|taggings|tags)"\.\*/ })
        end

        it "should return one taggings per (two) item" do
          @model.active_taggings.collect(&:class).should == [
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging
          ]
        end
      end

      context "when things are really complicated" do
        before do
          tagged_model_delete_all(@model)

          @one   = FactoryGirl.create(@model_sym, title: "Item One")
          @two   = FactoryGirl.create(@model_sym, title: "Item Two")
          @three = FactoryGirl.create(@model_sym, title: "Item Three")
          @four  = FactoryGirl.create(@model_sym, title: "Item Four")
          @five  = FactoryGirl.create(@model_sym, title: "Item Five")
          @six   = FactoryGirl.create(@model_sym, title: "Item Six")
          @seven = FactoryGirl.create(@model_sym, title: "Item Seven", enabled: false)
          @eight = FactoryGirl.create(@model_sym, title: "Item Eight", enabled: false)

          @one.category_list.add("tag_one")
          @two.category_list.add("tag_one")
          @three.category_list.add("tag_two")
          @four.category_list.add("tag_two")
          @four.category_list.add("tag_three")
          @five.category_list.add("tag_four")
          @seven.category_list.add("tag_four")
          @seven.category_list.add("tag_three")

          [@one, @two, @three, @four, @five, @six, @seven, @eight].each do |item|
            item.save
          end
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
             count: 1..3, matching: /^SELECT "(#{@model.table_name}|taggings|tags)"\.\*/ })
        end

        it "should return the correct number of taggings" do
          @model.active_taggings.collect(&:class).should == [
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging
          ]
        end

        it "should return taggings with the correct items" do
          @model.active_taggings.collect {|tagging| tagging.taggable }.should == [
              @one, @two, @three, @four, @four, @five
          ]
        end

        it "should return taggings with the correct tags" do
          active_taggings_map = [
              ["tag_one", @one],
              ["tag_one", @two],
              ["tag_two", @three],
              ["tag_three", @four],
              ["tag_two", @four],
              ["tag_four", @five]
          ]
          @model.active_taggings.each_with_index do |tagging, index|
            tagging.tag.name.should == active_taggings_map[index][0]
            tagging.taggable.should == active_taggings_map[index][1]
          end
        end
      end
    end

    context ".tagged_items_from_taggings" do
      before do
        tagged_model_delete_all(@model)
      end

      context "when empty" do
        it "should return an empty array" do
          taggings = []
          @model.tagged_items_from_taggings(taggings).should == []
        end
      end

      context "when items have one tag" do
        it "should return an array of all tagged items" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym)
          four  = FactoryGirl.create(@model_sym, enabled: false)
          [one, two, three, four].each do |item|
            item.category_list.add("tag_one")
            item.save
          end
          @model.tagged_items_from_taggings(@model.active_taggings).should == [
              one, two, three
          ]
        end
      end

      context "when items have many tags" do
        it "should return an array of all taggings" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym, enabled: false)
          four  = FactoryGirl.create(@model_sym, enabled: false)

          one.category_list.add("tag_one_one")
          one.category_list.add("tag_one_two")
          two.category_list.add("tag_two_one")
          two.category_list.add("tag_two_two")
          two.category_list.add("tag_two_three")
          three.category_list.add("tag_three_one")
          four.category_list.add("tag_four_one")
          four.category_list.add("tag_four_two")

          [one, two, three, four].map(&:save)

          @model.tagged_items_from_taggings(@model.active_taggings).should == [
              one, one, two, two, two
          ]
        end
      end
    end

    context ".tags_from_taggings" do
      before do
        tagged_model_delete_all(@model)
      end

      context "when empty" do
        it "should return an empty array" do
          taggings = []
          @model.tags_from_taggings(taggings).should == []
        end
      end

      context "when one tagging has one tag" do
        it "should return an array of one tag" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.save
          taggings = [ item.taggings.last ]
          @model.tags_from_taggings(taggings).collect(&:name).should == ["tag_one"]
        end
      end

      context "when multiple taggings have one tag" do
        it "should return an array of one tag" do
          5.times do
            item = FactoryGirl.create(@model_sym)
            item.category_list.add("tag_one")
            item.save
          end
          taggings = [ @model.last.taggings.last ]
          @model.tags_from_taggings(taggings).collect(&:name).should == ["tag_one"]
        end
      end

      context "when one tagging has multiple tags" do
        it "should return an array of many unique tags" do
          item = FactoryGirl.create(@model_sym)
          category_list = item.category_list
          category_list.add("tag_one")
          category_list.add("tag_two")
          category_list.add("tag_three")
          item.save
          @model.tags_from_taggings(item.taggings).collect(&:name).should == [
              "tag_one",
              "tag_three",
              "tag_two"
          ]
        end
      end

      context "when multiple taggings have multiple tags" do
        it "should return an array of many unique tags" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym)
          four  = FactoryGirl.create(@model_sym)
          five  = FactoryGirl.create(@model_sym)

          one.category_list.add("tag_one")
          two.category_list.add("tag_one")
          two.category_list.add("tag_two")
          three.category_list.add("tag_two")
          three.category_list.add("tag_three")
          [one, two, three, four, five].map(&:save)

          @model.tags_from_taggings(@model.active_taggings).collect(&:name).should == [
              "tag_one",
              "tag_three",
              "tag_two"
          ]
        end
      end

      context "when things are really complicated" do
        it "should return an array of many unique tags" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym)
          four  = FactoryGirl.create(@model_sym, enabled: false)
          five  = FactoryGirl.create(@model_sym, enabled: false)

          one.category_list.add("tag_one")
          two.category_list.add("tag_one")
          two.category_list.add("tag_two")
          three.category_list.add("tag_two")
          three.category_list.add("tag_three")
          four.category_list.add("tag_three")
          five.category_list.add("tag_four")
          [one, two, three, four, five].map(&:save)

          @model.tags_from_taggings(@model.active_taggings).collect(&:name).should == [
              "tag_one",
              "tag_three",
              "tag_two"
          ]
        end
      end
    end

    context ".tag_names_from_taggings" do
      before do
        tagged_model_delete_all(@model)
      end

      context "when empty" do
        it "should return an empty array" do
          taggings = []
          @model.tag_names_from_taggings(taggings).should == []
        end
      end

      context "when one item has one tag" do
        it "should return the tag name" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.save

          @model.tag_names_from_taggings(@model.active_taggings).should == [
              "tag_one"
          ]
        end
      end

      context "when multiple items have one tag" do
        it "should return one tag name" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym)
          [one, two, three].each do |item|
            item.category_list.add("tag_one")
            item.save
          end

          @model.tag_names_from_taggings(@model.active_taggings).should == [
              "tag_one"
          ]
        end
      end

      context "when one item has multiple tags" do
        it "should return the tag names" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.category_list.add("tag_two")
          item.category_list.add("tag_three")
          item.save

          @model.tag_names_from_taggings(@model.active_taggings).should == [
              "tag_one", "tag_three", "tag_two"
          ]
        end
      end

      context "when multiple items have multiple tags" do
        it "should return the tag names" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym)
          one.category_list.add("tag_one")
          one.category_list.add("tag_two")
          two.category_list.add("tag_two")
          two.category_list.add("tag_three")
          three.category_list.add("tag_three")
          three.category_list.add("tag_four")
          [one, two, three].map(&:save)

          @model.tag_names_from_taggings(@model.active_taggings).should == [
              "tag_four", "tag_one", "tag_three", "tag_two"
          ]
        end
      end

      context "when things are really complicated" do
        it "should return the tag names" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym, enabled: false)
          one.category_list.add("tag_one")
          one.category_list.add("tag_two")
          two.category_list.add("tag_two")
          two.category_list.add("tag_three")
          three.category_list.add("tag_three")
          three.category_list.add("tag_four")
          [one, two, three].map(&:save)

          @model.tag_names_from_taggings(@model.active_taggings).should == [
              "tag_one", "tag_three", "tag_two"
          ]
        end
      end
    end

    context ".first_items_from_tags_from_taggings" do
      before do
        tagged_model_delete_all(@model)
      end

      context "when empty" do
        it "should return an empty Hash" do
          taggings = []
          @model.first_items_from_tags_from_taggings(taggings).should == {}
        end
      end

      context "when one item has one tag" do
        it "should return a Hash of the tag and item" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.save

          @model.first_items_from_tags_from_taggings(@model.active_taggings).should == {
              "tag_one" => item
          }
        end
      end

      context "when multiple items have one tag" do
        it "should return a Hash of the tag and item" do
          items = [
              FactoryGirl.create(@model_sym),
              FactoryGirl.create(@model_sym),
              FactoryGirl.create(@model_sym),
              FactoryGirl.create(@model_sym),
              FactoryGirl.create(@model_sym)
          ]
          items.each do |item|
            item.category_list.add("tag_one")
            item.save
          end

          @model.first_items_from_tags_from_taggings(@model.active_taggings).should == {
              "tag_one" => items.first
          }
        end
      end

      context "when one item has multiple tags" do
        it "should return a Hash of the tags and item" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.category_list.add("tag_two")
          item.category_list.add("tag_three")
          item.save

          @model.first_items_from_tags_from_taggings(@model.active_taggings).should == {
              "tag_one"   => item,
              "tag_two"   => item,
              "tag_three" => item
          }
        end
      end

      context "when multiple items have multiple tags" do
        it "should return a Hash of the tags and items" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym)
          four  = FactoryGirl.create(@model_sym)

          one.category_list.add("tag_one")
          two.category_list.add("tag_one")
          two.category_list.add("tag_two")
          three.category_list.add("tag_two")
          three.category_list.add("tag_two")
          [one, two, three, four].map(&:save)

          @model.first_items_from_tags_from_taggings(@model.active_taggings).should == {
              "tag_one" => one,
              "tag_two" => two
           }
        end
      end

      context "when things are complicated" do
        it "should return a Hash of the tags and items" do
          one   = FactoryGirl.create(@model_sym)
          two   = FactoryGirl.create(@model_sym)
          three = FactoryGirl.create(@model_sym)
          four  = FactoryGirl.create(@model_sym, enabled: false)
          five  = FactoryGirl.create(@model_sym, enabled: false)

          one.category_list.add("tag_one")
          two.category_list.add("tag_two")
          two.category_list.add("tag_three")
          three.category_list.add("tag_three")
          three.category_list.add("tag_four")
          four.category_list.add("tag_four")

          [one, two, three, four, five].map(&:save)

          @model.first_items_from_tags_from_taggings(@model.active_taggings).should == {
              "tag_one"   => one,
              "tag_two"   => two,
              "tag_three" => two,
              "tag_four"  => three
          }
        end
      end
    end
  end
end
