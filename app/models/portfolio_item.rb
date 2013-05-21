class PortfolioItem  # < ActiveRecord::Base
  def title
    return "Title!"
  end

  def description
    return "Description!"
  end

  def image_filename
    return '123.jpg'
  end

  def thumbnail_filename
    return "123_thumb.jpg"
  end
end
