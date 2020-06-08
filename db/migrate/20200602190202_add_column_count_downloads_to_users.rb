class AddColumnCountDownloadsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.integer :projects_downloads, default: 0
      t.integer :transactions_downloads, default: 0
      t.integer :future_projects_downloads, default: 0
    end
  end
end
