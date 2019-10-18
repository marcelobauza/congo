class CreateProjectPrimaryData < ActiveRecord::Migration[5.2]
  def change
    create_table :project_primary_data do |t|
      t.integer :parcel_id
      t.integer :year
      t.integer :bimester
      t.integer :proj_qty
      t.integer :offer
      t.integer :availability
      t.integer :vmr
      t.numeric :vmd
      t.numeric :vvm
      t.numeric :mas
      t.numeric :usable_m2
      t.numeric :terrace
      t.numeric :uf_m2
      t.integer :uf
      t.numeric :uf_m2_u
      t.numeric :pxqr
      t.numeric :pxqd
      t.timestamps
    end
  end
end
