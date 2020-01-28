class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.references :expense_type, foreign_key: true
      t.numeric :abc1, precision: 12, scale: 2 
      t.numeric :c2, precision: 12, scale: 2
      t.numeric :c3, precision: 12, scale: 2
      t.numeric :d, precision: 12, scale: 2
      t.numeric :e, precision: 12, scale: 2
      t.boolean :santiago_only

      t.timestamps
    end
  end
end
