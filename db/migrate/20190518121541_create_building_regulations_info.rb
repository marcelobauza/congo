class CreateBuildingRegulationsInfo < ActiveRecord::Migration[5.2]
  def change
    create_view :building_regulations_info
  end
end
