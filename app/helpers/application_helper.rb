module ApplicationHelper
  def active_action?(c, a=nil)
    return (controller.controller_name == c) if a.nil?
    return (controller.controller_name == c && controller.action_name == a)
  end
end
