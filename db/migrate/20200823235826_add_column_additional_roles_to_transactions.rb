class AddColumnAdditionalRolesToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :additional_roles, :string
  end
end
