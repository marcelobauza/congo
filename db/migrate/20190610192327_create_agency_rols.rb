class CreateAgencyRols < ActiveRecord::Migration[5.2]
  def change
    create_table :agency_rols do |t|
      t.string :rol
      t.integer :project_id
      t.references :agency, foreign_key: true

      t.timestamps
    end
  end
end
