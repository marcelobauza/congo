class AddColumnCollectionDateToBots < ActiveRecord::Migration[5.2]
  def change
    add_column :bots, :collection_date, :date
  end
end
