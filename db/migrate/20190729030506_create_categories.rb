class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name_en
      t.string :name_es
      t.boolean :income
      t.integer :position

      t.timestamps
    end
  end
end
