class CreateProjectInstanceMixes < ActiveRecord::Migration[5.2]
  def change
    create_table :project_instance_mixes do |t|
      t.references :project_instance, foreign_key: true
      t.references :mix
      t.numeric :percentage, default: 0
      t.integer :stock_units
      t.numeric :mix_m2_field
      t.numeric :mix_m2_built
      t.numeric :mix_usable_square_meters
      t.numeric :mix_terrace_square_meters
      t.numeric :mix_uf_m2
      t.numeric :mix_selling_speed
      t.numeric :mix_uf_value
      t.integer :living_room
      t.string :service_room
      t.integer :h_office
      t.decimal :discount
      t.numeric :uf_min
      t.numeric :uf_max
      t.numeric :uf_parking
      t.numeric :uf_cellar
      t.numeric :common_expenses
      t.numeric :withdrawal_percent
      t.integer :total_units
      t.decimal :t_min
      t.decimal :t_max
      t.string :home_type
      t.string :model

      t.timestamps
    end
  end
end
