class CreateMonthlyCensusIncomes < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_census_incomes do |t|
      t.numeric :abc1, default: 0, null: false
      t.numeric :c2, default: 0, null: false  
      t.numeric :c3, default: 0, null: false
      t.numeric :d, default: 0, null: false
      t.numeric :e, default: 0, null: false

      t.timestamps
    end
  end
end
