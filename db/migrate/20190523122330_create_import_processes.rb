class CreateImportProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :import_processes do |t|
      t.string :status
      t.string :file_path
      t.integer :processed
      t.integer :inserted
      t.integer :updated
      t.integer :failed
      t.references :user, foreign_key: true
      t.string :data_source
      t.string :original_filename

      t.timestamps
    end
  end
end
