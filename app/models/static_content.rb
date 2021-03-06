class StaticContent < ApplicationRecord
  def self.load(page, part=nil)
    c = self.find_by_page_and_part(page, part)
    return c.first.body if c.is_a?(Array)
    return c.body if c.is_a?(self)
    return ""
  end
end