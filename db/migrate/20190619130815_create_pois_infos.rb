class CreatePoisInfos < ActiveRecord::Migration[5.2]
  def change
    create_view :pois_infos
  end
end
