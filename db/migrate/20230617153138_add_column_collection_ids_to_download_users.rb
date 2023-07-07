class AddColumnCollectionIdsToDownloadUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :downloads_users, :title, :string
    add_column :downloads_users, :collection_ids, :integer, array: true, default: []
    add_column :downloads_users, :layer_type, :string
    add_column :downloads_users, :disabled, :boolean, default: false
  end
end
