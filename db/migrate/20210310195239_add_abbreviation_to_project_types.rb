class AddAbbreviationToProjectTypes < ActiveRecord::Migration[5.2]
  def change
    change_table :project_types do |t|
      t.string :abbreviation
    end
  end
end
