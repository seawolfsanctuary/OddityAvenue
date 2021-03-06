class PortfolioItem < ApplicationRecord
  include Item

  include TaggableItem
  acts_as_taggable_on :categories

  def move
    # -1 couldn't create
    #  0 couldn't destroy
    #  1 success

    destination = ShopItem.new

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