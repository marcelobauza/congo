class AddColumnLayersTypesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :layer_types, :integer, array: true, default: []
  end
end
