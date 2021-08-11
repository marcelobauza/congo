class AddColumnTaxAppraisalToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :tax_appraisal, :integer
  end
end
