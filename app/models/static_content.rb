class StaticContent < ActiveRecord::Base
  def self.load(page, part=nil)
    Rails.logger.info "  * Finding content: #{page} -> #{part}"
    return part == :email ? "[email-address]" : "<p>(this is the #{page} #{part})</p>"
  end
end
