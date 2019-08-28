class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.jsonb :properties
      t.string :layer_type
      t.references :user

      t.timestamps
    end
  end
end
