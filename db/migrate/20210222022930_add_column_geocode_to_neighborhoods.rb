class AddColumnGeocodeToNeighborhoods < ActiveRecord::Migration[5.2]
  def change
    add_column :neighborhoods, :geocode, :string
  end
end
