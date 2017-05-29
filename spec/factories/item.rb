FactoryGirl.define do
  factory :item do
    title { [ "Skeleton", "Eagle", "Shrunken Head", "Chicken", "Sausage Monkey", "Banana Baboon" ].sample }

    description "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec mi purus, non convallis libero. Praesent sit amet massa quam. Ut id leo enim, et posuere ipsum. Maecenas semper orci ac augue pretium at aliquet dolor consectetur. In scelerisque lectus ut sem viverra posuere. Fusce volutpat ultrices consequat. In tempor euismod elit, quis dignissim nibh bibendum quis. Etiam convallis mollis orci, fermentum sodales nisi adipiscing quis."

    sequence(:image_filename_1) { |i| "http://example.org/images/#{i}-1.jpg" }
    sequence(:image_filename_2) { |i| "http://example.org/images/#{i}-2.jpg" }
    sequence(:image_filename_3) { |i| "http://example.org/images/#{i}-3.jpg" }

    sequence(:thumbnail_filename) { |i| "http://example.org/images/#{i}_thumb.jpg" }
  end
  
  factory :portfolio_item do
  end

  factory :shop_item do
    quantity 1
    price    0.00
  end
end