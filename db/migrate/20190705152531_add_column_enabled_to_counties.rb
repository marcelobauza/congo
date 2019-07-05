class AddColumnEnabledToCounties < ActiveRecord::Migration[5.2]
  def change
    add_column :counties, :enabled, :boolean, default: 'false'
  end
end
