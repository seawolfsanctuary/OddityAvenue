class PriceValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:price] << 'cannot be less than zero' unless record[:price] >= 0.00
  end
end

class QuantityValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:quantity] << 'cannot be less than zero' unless record[:quantity] >= 0
  end
end

class ShopItem < ActiveRecord::Base
  include Item

  attr_accessible :title, :description,
    :image_filename_1, :image_filename_2, :image_filename_3,
    :thumbnail_filename, :enabled,
    :quantity, :price

  validates_with PriceValidator
  validates_with QuantityValidator

  def price
    return "&pound;#{"%.2f" % self[:price]}".html_safe
  end
end
