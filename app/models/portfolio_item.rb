class PortfolioItem  # < ActiveRecord::Base
  def id
    return 4
  end

  def title
    return "Title!"
  end

  def description
    return "Description!"
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
