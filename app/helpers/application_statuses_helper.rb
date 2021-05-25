module ApplicationStatusesHelper
  def application_statuses_for_select
    ApplicationStatus.where(user_id: current_user.id).collect { |c| [c.name, c.id]}
  end

  def sortable(column, title)
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to (("#{title} #{content_tag(:i, '', :class => "fa fa-chevron-#{direction == 'asc' ? 'up': 'down'}") if css_class.present?}").html_safe), {:sort => column, :direction => direction, :remote => true, :id => 'sessions'}, {:class => css_class}
  end
end
