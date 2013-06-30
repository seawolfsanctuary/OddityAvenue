FactoryGirl.define do
  factory :portfolio_item do
    title { [ "Skeleton", "Eagle", "Shrunken Head", "Chicken", "Sausage Monkey", "Banana Baboon" ].sample }

    description "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec mi purus, non convallis libero. Praesent sit amet massa quam. Ut id leo enim, et posuere ipsum. Maecenas semper orci ac augue pretium at aliquet dolor consectetur. In scelerisque lectus ut sem viverra posuere. Fusce volutpat ultrices consequat. In tempor euismod elit, quis dignissim nibh bibendum quis. Etiam convallis mollis orci, fermentum sodales nisi adipiscing quis."

    sequence(:image_filename_1) { |i| "#{i}-1.jpg" }
    sequence(:image_filename_2) { |i| "#{i}-2.jpg" }
    sequence(:image_filename_3) { |i| "#{i}-3.jpg" }

    sequence(:thumbnail_filename) { |i| "#{i}_thumb.jpg" }

    for_sale false
    hidden   false
  end
end
