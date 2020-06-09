module Admin::RolesHelper
  def roles_for_select
    roles = Role.all
    roles.map { |role| [role.name, role.id] }
  end

  def roles
    Role.all.ordered
  end
end
