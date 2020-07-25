module ApplicationStatusesHelper
  def application_statuses_for_select
    ApplicationStatus.where(user_id: current_user.id).collect { |c| [c.name, c.id]}
  end
end
