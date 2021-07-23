class AddColumnTransactionIdsToFlexReports < ActiveRecord::Migration[5.2]
  def change
    change_table :flex_reports do |t|
      t.text :transaction_ids, array: true , default: []
    end
  end
end
