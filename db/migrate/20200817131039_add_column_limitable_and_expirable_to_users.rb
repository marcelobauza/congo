class AddColumnLimitableAndExpirableToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :unique_session_id
      t.datetime :last_activity_at
      t.datetime :expired_at
    end

    add_index :users, :last_activity_at
    add_index :users, :expired_at
  end
end
