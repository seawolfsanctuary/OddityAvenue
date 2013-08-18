class PortfolioItem < ActiveRecord::Base
  include Item
  acts_as_taggable_on :categories

  attr_accessible :title, :description,
    :image_filename_1, :image_filename_2, :image_filename_3,
    :thumbnail_filename, :category_list, :enabled
end
