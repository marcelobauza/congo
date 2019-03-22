module ApplicationHelper
  def safe_action_name action
    return "action_#{action}"
  end
end
