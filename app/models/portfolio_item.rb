class PortfolioItem  # < ActiveRecord::Base
  def id
    return rand(5) + 1
  end

  def title
    titles = [ "Skeleton", "Eagle", "Shrunken Head", "Chicken", "Sausage Monkey", "Banana Baboon" ]
    return titles[rand(5)]
  end

  def description
    return "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec mi purus, non convallis libero. Praesent sit amet massa quam. Ut id leo enim, et posuere ipsum. Maecenas semper orci ac augue pretium at aliquet dolor consectetur. In scelerisque lectus ut sem viverra posuere. Fusce volutpat ultrices consequat. In tempor euismod elit, quis dignissim nibh bibendum quis. Etiam convallis mollis orci, fermentum sodales nisi adipiscing quis."
  end

  def image_filename_1
    return '1.jpg'
  end

  def image_filename_2
    return '2.jpg'
  end

  def image_filename_3
    return '3.jpg'
  end

  def thumbnail_filename
    return "1_thumb.jpg"
  end
end
