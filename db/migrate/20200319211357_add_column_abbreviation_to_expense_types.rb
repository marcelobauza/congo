class AddColumnAbbreviationToExpenseTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_types, :abbreviation, :string, limit: 200
  end
end
