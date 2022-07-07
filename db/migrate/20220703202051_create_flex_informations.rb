class CreateFlexInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :flex_informations do |t|
      t.text :info
      t.string :video_link
      t.string :tutorial_link

      t.timestamps
    end
  end
end
