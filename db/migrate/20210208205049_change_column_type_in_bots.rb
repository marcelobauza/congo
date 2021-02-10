class ChangeColumnTypeInBots < ActiveRecord::Migration[5.2]
  def change
    rename_column :bots, :type, :property_status
  end
end
