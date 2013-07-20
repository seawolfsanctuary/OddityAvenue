class PortfolioItem < ActiveRecord::Base
  include Item

  attr_accessible :title, :description,
    :image_filename_1, :image_filename_2, :image_filename_3,
    :thumbnail_filename, :enabled
end
