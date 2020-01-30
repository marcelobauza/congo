class AddColumnIdentifiersForLayersToFeedback < ActiveRecord::Migration[5.2]
  def change
    add_column :feedbacks, :row_id, :integer
  end
end
