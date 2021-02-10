class AddNeighborhoodsIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :neighborhoods, :the_geom, using: :gist
  end
end
