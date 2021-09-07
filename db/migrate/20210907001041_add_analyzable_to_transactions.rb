class AddAnalyzableToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :analyzable, :boolean, default: true
  end
end
