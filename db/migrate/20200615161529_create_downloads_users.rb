class CreateDownloadsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :downloads_users do |t|
      t.integer :transactions, default: 0
      t.integer :projects, default: 0
      t.integer :future_projects, default: 0
      t.references :user
      t.timestamps
    end
  end
end
