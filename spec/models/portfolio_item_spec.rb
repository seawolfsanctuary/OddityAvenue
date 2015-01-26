require 'spec_helper'

describe PortfolioItem do
  context "initialisation" do
    it "should have various attributes accessible" do
      %w{ title description
          image_filename_1 image_filename_2 image_filename_3
          thumbnail_filename categories enabled
      }.each do |a|
        PortfolioItem.new.should respond_to("#{a}".to_sym)
        PortfolioItem.new.should respond_to("#{a}=".to_sym)
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
      lambda { @i.move }.should_not raise_error
    end

    it "should return -1 when the PortfolioItem could not be created" do
      ShopItem.any_instance.should_receive(:create).and_return(false)
      @i.move.should == -1
    end

    it "should not attempt to remove the ShopItem when the PortfolioItem could not be created" do
      ShopItem.any_instance.should_receive(:create).and_return(false)
      PortfolioItem.any_instance.should_not_receive(:destroy)
      PortfolioItem.any_instance.should_not_receive(:delete)
      @i.move
    end

    it "should return  0 when the ShopItem could not be removed" do
      PortfolioItem.any_instance.should_receive(:destroy).and_return(false)
      @i.move.should == 0
    end

    it "should return  1 when successful" do
      @i.move.should == 1
    end

    it "should create a ShopItem" do
      lambda { @i.move }.should change(ShopItem, :count).by(1)
    end

    it "should destroy the PortfolioItem" do
      lambda { @i.move }.should change(PortfolioItem, :count).by(-1)
    end

    it "should loop through the attributes" do
      @i.move
      ShopItem.last.title.should == @i.title
      ShopItem.last.description.should == @i.description
    end

    it "should handle source-only attributes" do
      pending "how do we test the begin/rescue?"
      @i.move
    end

    it "should set default destination-only attributes" do
      @i.move
      s = ShopItem.last
      s.quantity.should_not be_nil
    end
  end
end
