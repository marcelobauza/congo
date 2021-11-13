class RenameColumnTypeRegistrationToTransactions < ActiveRecord::Migration[5.2]
  def change
    rename_column :transactions, :type_gistration, :type_registration
  end
end
