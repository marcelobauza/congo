module RolesHelper

  def roles_for_select
    roles = Role.all
    roles.map { |role| [role.name, role.id] }
  end
end
