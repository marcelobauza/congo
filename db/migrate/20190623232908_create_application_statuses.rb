class CreateApplicationStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :application_statuses do |t|
      t.string :name
      t.string :description
      t.references :user
      t.text :polygon
      t.references :layer_type
      t.jsonb :filters

      t.timestamps
    end
  end
end
