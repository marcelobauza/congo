class AddRentProjectsIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :rent_projects, :the_geom, using: :gist
    add_index :rent_projects, :bimester
    add_index :rent_projects, :year
  end
end
