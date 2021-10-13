class UpdateFlexOrdersTable < ActiveRecord::Migration[5.2]
  def change
    change_column :flex_orders, :status, :string, :default => "pending"
    FlexOrder.where(status: "true").update_all(status: "approved")
    add_column :flex_orders, :unit_price,         :integer
    add_column :flex_orders, :collection_id,      :string
    add_column :flex_orders, :collection_status,  :string
    add_column :flex_orders, :payment_id,         :string
    add_column :flex_orders, :external_reference, :string
    add_column :flex_orders, :payment_type,       :string
    add_column :flex_orders, :merchant_order_id,  :string
    add_column :flex_orders, :preference_id,      :string
    add_column :flex_orders, :site_id,            :string
    add_column :flex_orders, :processing_mode,    :string
    add_column :flex_orders, :merchant_account_id,:string
  end
end
