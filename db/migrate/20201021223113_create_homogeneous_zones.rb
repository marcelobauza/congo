class CreateHomogeneousZones < ActiveRecord::Migration[5.2]
  def change
    create_table :homogeneous_zones do |t|
      t.integer :objectid, null: false, default: 0
      t.integer :cnt_cod_zc, null: false, default: 0
      t.integer :sum_house_p, null: false, default: 0
      t.integer :sum_house_a, null: false, default: 0
      t.integer :sum_house_o, null: false, default: 0
      t.integer :sum_other_p, null: false, default: 0
      t.integer :sum_other_o, null: false, default: 0
      t.integer :total_population, null: false, default: 0
      t.integer :total17, null: false, default: 0
      t.integer :sum_dept_p, null: false, default: 0
      t.integer :sum_dept_a, null: false, default: 0
      t.integer :sum_dept_o, null: false, default: 0
      t.integer :sum_other_a, null: false, default: 0
      t.integer :total12, null: false, default: 0
      t.integer :mp250, null: false, default: 0
      t.numeric :shape_leng, null: false, default: 0, precision: 10, scale: 2
      t.numeric :shape_area, null: false, default: 0, precision: 10, scale: 2
      t.integer :house, null: false, default: 0
      t.integer :dpto, null: false, default: 0
      t.integer :house_prop, null: false, default: 0
      t.integer :dept_prop, null: false, default: 0
      t.integer :house_arr, null: false, default: 0
      t.integer :dept_arr, null: false, default: 0
      t.string  :province, null: false
      t.string :commune, null: false
      t.string :region, null: false
      t.string :province, null: false
      t.references :conty
      t.integer :zone_txt, null: false, default: 0
      t.integer :district_txt, null: false, default: 0
      t.integer :cod_zc_txt, null: false, default: 0
      t.integer :occupied_dwelling_17, null: false, default: 0
      t.integer :vancant_dwelling_17, null: false, default: 0
      t.integer :house_17, null: false, default: 0
      t.integer :dept_17, null: false, default: 0
      t.multi_polygon :the_geom, srid: 4326

      t.timestamps
    end
  end
end
