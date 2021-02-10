class AddRentTransactionsIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :rent_transactions, :the_geom, using: :gist
    add_index :rent_transactions, :year
    add_index :rent_transactions, :bimester
  end
end
