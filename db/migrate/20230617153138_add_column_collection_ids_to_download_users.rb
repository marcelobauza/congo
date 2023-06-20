class AddColumnCollectionIdsToDownloadUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :downloads_users, :title, :string
    add_column :downloads_users, :collection_ids, :integer, array: true, default: []
  end
end
