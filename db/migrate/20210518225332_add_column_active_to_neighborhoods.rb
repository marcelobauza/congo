class AddColumnActiveToNeighborhoods < ActiveRecord::Migration[5.2]
  def change
    change_table :neighborhoods do |t|
      t.boolean :active, default: true
    end
  end
end
