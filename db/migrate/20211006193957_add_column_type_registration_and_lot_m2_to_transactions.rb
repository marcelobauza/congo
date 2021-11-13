class AddColumnTypeRegistrationAndLotM2ToTransactions < ActiveRecord::Migration[5.2]
  def change
    change_table :transactions do |t|
      t.string :type_gistration
      t.numeric :lot_m2, precision: 12, scale: 2
    end
  end
end
