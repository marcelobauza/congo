class RemoveExtensionTopology < ActiveRecord::Migration[5.2]
  def change
    disable_extension "postgis_topology"
  end
end
