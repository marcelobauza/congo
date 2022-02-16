class AddColumnCollectionDateToBots < ActiveRecord::Migration[5.2]
  def change
    add_column :bots, :collection_date, :date

    Bot.all.each do |bot|
      bot.update_attribute :collection_date, bot.created_at
    end
  end
end
