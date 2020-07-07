class CreateCountiesEnabledByUsers < ActiveRecord::Migration[5.2]
  def change
    create_view :counties_enabled_by_users
  end
end
