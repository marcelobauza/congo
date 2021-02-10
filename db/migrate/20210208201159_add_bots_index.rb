class AddBotsIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :bots, :the_geom, using: :gist
    add_index :bots, :bimester
    add_index :bots, :year
  end
end
