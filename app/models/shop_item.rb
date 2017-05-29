class ShopItem < ApplicationRecord
  include Item

  include TaggableItem
  acts_as_taggable_on :categories

  require 'validators/price_validator.rb'
  validates_with PriceValidator

  require 'validators/quantity_validator.rb'
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
        destination.send("#{key}=".to_sym, value) unless key.to_sym == :id
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