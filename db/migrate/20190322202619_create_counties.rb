class CreateCounties < ActiveRecord::Migration[5.2]
  def change
    create_table :counties do |t|
      t.string :name
      t.string :code
      t.boolean :transaction_data
      t.boolean :demography_data
      t.boolean :legislation_data
      t.boolean :sales_project_data
      t.boolean :future_project_data
      t.string :commercial_project_data
      t.integer :code_sii
      t.integer :name_last_project_future
      t.st_polygon :the_geom
      t.timestamps
    end
  end
end
