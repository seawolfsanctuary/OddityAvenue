require 'spec_helper'

describe Item do
  class DummyItem
    include Item

    attr_accessor :image_filename_1, :image_filename_2,
      :image_filename_3, :thumbnail_filename
  end

  context "#images_count" do
    it "should count the number of image filenames set" do
      i = DummyItem.new
      i.image_filename_1 = nil
      i.image_filename_2 = nil
      i.image_filename_3 = nil
      i.thumbnail_filename = nil
      i.images_count.should == 0

      i = DummyItem.new
      i.image_filename_1 = "1.jpg"
      i.image_filename_2 = nil
      i.image_filename_3 = nil
      i.thumbnail_filename = nil
      i.images_count.should == 1

      i = DummyItem.new
      i.image_filename_1 = nil
      i.image_filename_2 = "2.jpg"
      i.image_filename_3 = "3.jpg"
      i.thumbnail_filename = nil
      i.images_count.should == 2

      i = DummyItem.new
      i.image_filename_1 = "1.jpg"
      i.image_filename_2 = "2.jpg"
      i.image_filename_3 = "3.jpg"
      i.thumbnail_filename = "t.jpg"
      i.images_count.should == 3
    end
  end
end
