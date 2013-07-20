module Item
  def images_count
    count = 0
    count += 1 if self.image_filename_1.present?
    count += 1 if self.image_filename_2.present?
    count += 1 if self.image_filename_3.present?
    return count
  end
end
