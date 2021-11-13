class CreateFlexOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :flex_orders do |t|
      t.references :user, foreign_key: true
      t.integer :amount
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
