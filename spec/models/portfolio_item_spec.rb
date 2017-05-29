require 'spec_helper'

describe PortfolioItem do
  context "initialisation" do
    it "should have various attributes accessible" do
      %w{ title description
          image_filename_1 image_filename_2 image_filename_3
          thumbnail_filename categories enabled
      }.each do |a|
        expect(PortfolioItem.new).to respond_to("#{a}".to_sym)
        expect(PortfolioItem.new).to respond_to("#{a}=".to_sym)
      end
    end
  end

  context "#move" do
    before(:each) do
      ShopItem.delete_all
      PortfolioItem.delete_all
      @i = FactoryGirl.create(:portfolio_item)
    end

    it "should override Item#move" do
      expect { @i.move }.not_to raise_error # NoMethodError
    end

    it "should return -1 when the PortfolioItem could not be created" do
      expect_any_instance_of(ShopItem).to receive(:save).and_return(false)
      expect(@i.move).to eq(-1)
    end

    it "should not attempt to remove the ShopItem when the PortfolioItem could not be created" do
      expect_any_instance_of(ShopItem).to receive(:save).and_return(false)
      expect_any_instance_of(PortfolioItem).not_to receive(:destroy)
      expect_any_instance_of(PortfolioItem).not_to receive(:delete)
      @i.move
    end

    it "should return  0 when the ShopItem could not be removed" do
      expect_any_instance_of(PortfolioItem).to receive(:destroy).and_return(false)
      expect(@i.move).to eq(0)
    end

    it "should return  1 when successful" do
      expect(@i.move).to eq(1)
    end

    it "should create a ShopItem" do
      expect { @i.move }.to change(ShopItem, :count).by(1)
    end

    it "should destroy the PortfolioItem" do
      expect { @i.move }.to change(PortfolioItem, :count).by(-1)
    end

    it "should loop through the attributes" do
      @i.move
      expect(ShopItem.last.title).to eq(@i.title)
      expect(ShopItem.last.description).to eq(@i.description)
    end

    it "should handle source-only attributes" do
      expect(@i).to receive(:attributes).and_return({"sourceOnlyAttr" => "Hello"})
      expect(ShopItem.new).not_to be_respond_to(:sourceOnlyAttr=)
      expect { @i.move }.not_to raise_exception
    end

    it "should set default destination-only attributes" do
      @i.move
      s = ShopItem.last
      expect(s.quantity).not_to be_nil
    end
  end

  context "tagged lookup" do
    before do
      @model = PortfolioItem
      @model_sym = @model.name.underscore.to_sym
    end

    context ".active_taggings" do
      context "when empty" do
        before do
          tagged_model_delete_all(@model)
        end

        it "should hit the database only once per Item, Tagging and Tag" do
          expect { @model.active_taggings }.to make_database_queries({
            count: 1..3, matching: /^SELECT "(#{@model.table_name}|taggings|tags)"\.\*/ })
        end

        it "should return every tagging" do
          expect(@model.active_taggings).to be_empty
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
          expect(@model.active_taggings.collect(&:class)).to eq([
            ActsAsTaggableOn::Tagging,
            ActsAsTaggableOn::Tagging
          ])
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
          expect(@model.active_taggings.collect(&:class)).to eq([])
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
          expect(@model.active_taggings.collect(&:class)).to eq([
            ActsAsTaggableOn::Tagging
          ])
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
          expect(@model.active_taggings.collect(&:class)).to eq([
            ActsAsTaggableOn::Tagging,
            ActsAsTaggableOn::Tagging,
            ActsAsTaggableOn::Tagging
          ])
        end
      end

      context "when things are really complicated" do
        before do
          tagged_model_delete_all(@model)

          @one   = FactoryGirl.create(@model_sym); @model.all
          @two   = FactoryGirl.create(@model_sym); @model.all
          @three = FactoryGirl.create(@model_sym); @model.all
          @four  = FactoryGirl.create(@model_sym); @model.all
          @five  = FactoryGirl.create(@model_sym); @model.all
          @six   = FactoryGirl.create(@model_sym); @model.all
          @seven = FactoryGirl.create(@model_sym, enabled: false); @model.all
          @eight = FactoryGirl.create(@model_sym, enabled: false); @model.all

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
          expect(@model.active_taggings.collect(&:class)).to eq([
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging,
              ActsAsTaggableOn::Tagging
          ])
        end

        it "should return taggings with the correct items" do
          expect(@model.active_taggings.collect {|tagging| tagging.taggable }).to eq([
              @one, @two, @three, @four, @four, @five
          ])
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
            expect(tagging.tag.name).to eq(active_taggings_map[index][0])
            expect(tagging.taggable).to eq(active_taggings_map[index][1])
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
          expect(@model.tagged_items_from_taggings(taggings)).to eq([])
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
          expect(@model.tagged_items_from_taggings(@model.active_taggings)).to eq([
              one, two, three
          ])
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

          expect(@model.tagged_items_from_taggings(@model.active_taggings)).to eq([
              one, one, two, two, two
          ])
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
          expect(@model.tags_from_taggings(taggings)).to eq([])
        end
      end

      context "when one tagging has one tag" do
        it "should return an array of one tag" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.save
          taggings = [ item.taggings.last ]
          expect(@model.tags_from_taggings(taggings).collect(&:name)).to eq(["tag_one"])
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
          expect(@model.tags_from_taggings(taggings).collect(&:name)).to eq(["tag_one"])
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
          expect(@model.tags_from_taggings(item.taggings).collect(&:name)).to eq([
              "tag_one",
              "tag_three",
              "tag_two"
          ])
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

          expect(@model.tags_from_taggings(@model.active_taggings).collect(&:name)).to eq([
              "tag_one",
              "tag_three",
              "tag_two"
          ])
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

          expect(@model.tags_from_taggings(@model.active_taggings).collect(&:name)).to eq([
              "tag_one",
              "tag_three",
              "tag_two"
          ])
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
          expect(@model.tag_names_from_taggings(taggings)).to eq([])
        end
      end

      context "when one item has one tag" do
        it "should return the tag name" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.save

          expect(@model.tag_names_from_taggings(@model.active_taggings)).to eq([
              "tag_one"
          ])
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

          expect(@model.tag_names_from_taggings(@model.active_taggings)).to eq([
              "tag_one"
          ])
        end
      end

      context "when one item has multiple tags" do
        it "should return the tag names" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.category_list.add("tag_two")
          item.category_list.add("tag_three")
          item.save

          expect(@model.tag_names_from_taggings(@model.active_taggings)).to eq([
              "tag_one", "tag_three", "tag_two"
          ])
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

          expect(@model.tag_names_from_taggings(@model.active_taggings)).to eq([
              "tag_four", "tag_one", "tag_three", "tag_two"
          ])
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

          expect(@model.tag_names_from_taggings(@model.active_taggings)).to eq([
              "tag_one", "tag_three", "tag_two"
          ])
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
          expect(@model.first_items_from_tags_from_taggings(taggings)).to eq({})
        end
      end

      context "when one item has one tag" do
        it "should return a Hash of the tag and item" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.save

          expect(@model.first_items_from_tags_from_taggings(@model.active_taggings)).to eq({
              "tag_one" => item
          })
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

          expect(@model.first_items_from_tags_from_taggings(@model.active_taggings)).to eq({
              "tag_one" => items.first
          })
        end
      end

      context "when one item has multiple tags" do
        it "should return a Hash of the tags and item" do
          item = FactoryGirl.create(@model_sym)
          item.category_list.add("tag_one")
          item.category_list.add("tag_two")
          item.category_list.add("tag_three")
          item.save

          expect(@model.first_items_from_tags_from_taggings(@model.active_taggings)).to eq({
              "tag_one"   => item,
              "tag_two"   => item,
              "tag_three" => item
          })
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

          expect(@model.first_items_from_tags_from_taggings(@model.active_taggings)).to eq({
              "tag_one" => one,
              "tag_two" => two
          })
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

          expect(@model.first_items_from_tags_from_taggings(@model.active_taggings)).to eq({
              "tag_one"   => one,
              "tag_two"   => two,
              "tag_three" => two,
              "tag_four"  => three
          })
        end
      end
    end
  end
end
