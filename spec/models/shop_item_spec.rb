require 'spec_helper'

describe ShopItem do
  context "initialisation" do
    it "should have inherited various attributes" do
      %w{ title description
          image_filename_1 image_filename_2 image_filename_3
          thumbnail_filename enabled
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
end
