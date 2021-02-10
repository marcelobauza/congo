class AddRentFutureProjectsIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :rent_future_projects, :the_geom, using: :gist
    add_index :rent_future_projects, :bimester
    add_index :rent_future_projects, :year
  end
end
