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
  acts_as_taggable_on :categories

  attr_accessible :title, :description,
    :image_filename_1, :image_filename_2, :image_filename_3,
    :thumbnail_filename, :enabled,
    :quantity, :price, :category_list

  validates_with PriceValidator
  validates_with QuantityValidator

  def price
    return "&pound;#{"%.2f" % self[:price]}".html_safe
  end

  def move
    # -1 couldn't create
    #  0 couldn't destroy
    #  1 success

    destination = PortfolioItem.new

    attributes.each do |key, value|
      begin
        destination.send("#{key}=".to_sym, value)
      rescue NoMethodError ; end
    end

    destination.category_list = categories.split(ActsAsTaggableOn.delimiter)

    if destination.save
      return (destroy.present? ? 1 : 0)
    else
      return -1
    end
  end
end
