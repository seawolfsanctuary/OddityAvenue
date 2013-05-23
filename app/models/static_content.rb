class StaticContent < ActiveRecord::Base
  def self.load(page, part=nil)
    Rails.logger.info "  * Finding content: #{page} -> #{part}"
    c = self.find_by_page_and_part(page, part)
    return c.first.body if c.is_a?(Array)
    return c.body if c.is_a?(self)
    return ""
  end
end
