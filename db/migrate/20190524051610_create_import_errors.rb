class CreateImportErrors < ActiveRecord::Migration[5.2]
  def change
    create_table :import_errors do |t|
      t.integer :import_process_id
      t.text :message
      t.integer :row_index

      t.timestamps
    end
  end
end
