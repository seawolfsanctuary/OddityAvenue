FactoryGirl.define do
  factory :portfolio_category, :class => ActsAsTaggableOn::Tag do |f|
    sequence(:category) { |n| "cat-#{n}" }
  end

  factory :shop_category, :class => ActsAsTaggableOn::Tag do |f|
    sequence(:category) { |n| "cat-#{n}" }
  end
end
