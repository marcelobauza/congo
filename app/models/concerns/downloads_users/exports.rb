module DownloadsUsers::Exports
  extend ActiveSupport::Concern

  module ClassMethods
    def export_csv_downloads_by_company company_id
      layers = %w(:projects future_projects transactions)

      du = DownloadsUser.includes(:user).where(users:  {company_id: company_id}).where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)

      return CsvParser.get_downloads_users_csv_data(du)
    end
  end
end
