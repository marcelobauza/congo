class AddColumnVhmoToProjects < ActiveRecord::Migration[5.2]
  def change
    change_table :projects do |t|
      t.numeric :vhmo, precision: 8, scale: 1, default: 0
    end
  end
end
