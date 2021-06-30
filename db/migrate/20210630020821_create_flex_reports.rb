class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :flex_reports do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.text :filters

      t.timestamps
    end
  end
end
