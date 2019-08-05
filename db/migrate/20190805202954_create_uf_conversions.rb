class CreateUfConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :uf_conversions do |t|
      t.date :uf_date
      t.string :uf_value

      t.timestamps
    end
  end
end
