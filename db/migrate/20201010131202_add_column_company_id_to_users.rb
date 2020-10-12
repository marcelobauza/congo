class AddColumnCompanyIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :company

    User.all.each do |u|
      company = Company.where(
        name: u.company,
        projects_downloads: 0,
        transactions_downloads: 0,
        future_projects_downloads: 0
      ).first_or_create!

      u.update_column :company_id, company.id
    end

    remove_column :users, :company
  end
end
