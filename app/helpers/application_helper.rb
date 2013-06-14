module ApplicationHelper
  def active_action?(c, a=nil)
    return (controller_name == c) if a.nil?
    return (controller_name == c && action_name == a)
  end
end
