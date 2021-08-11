class AddColumnTaxAppraisalToTaxLands < ActiveRecord::Migration[5.2]
  def change
    add_column :tax_lands, :tax_appraisal, :integer
  end
end
