class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :projects_downloads, null: false, default: 0
      t.integer :transactions_downloads, null: false, default: 0
      t.integer :future_projects_downloads, null: false, default: 0

      t.timestamps
    end
  end
end
