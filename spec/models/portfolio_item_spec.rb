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
end
