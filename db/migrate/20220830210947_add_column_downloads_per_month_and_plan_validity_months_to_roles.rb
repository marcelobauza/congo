class AddColumnDownloadsPerMonthAndPlanValidityMonthsToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :plan_validity_months, :integer, default: 0
  end
end
