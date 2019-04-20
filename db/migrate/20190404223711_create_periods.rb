class CreatePeriods < ActiveRecord::Migration[5.2]
  def change
    create_table :periods do |t|
      t.integer :bimester
      t.integer :year
      t.boolean :active

      t.timestamps
    end
  end
end
