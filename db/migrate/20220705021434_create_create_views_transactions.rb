class CreateCreateViewsTransactions < ActiveRecord::Migration[5.2]
  def change
    create_view :transaction_infos, materialized: true
  end
end
