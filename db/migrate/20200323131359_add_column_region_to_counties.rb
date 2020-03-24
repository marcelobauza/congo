class AddColumnRegionToCounties < ActiveRecord::Migration[5.2]
  def change
    add_reference :counties, :region, foreign_key: true
  end
end
