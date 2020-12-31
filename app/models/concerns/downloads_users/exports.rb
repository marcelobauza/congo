module DownloadsUsers::Exports
  extend ActiveSupport::Concern

  module ClassMethods
    def export_csv_downloads_by_company company_id, current_user
      layers = %w(:projects future_projects transactions)
      from_date = calculate_date current_user
      to_date   = from_date.next_month

      du = DownloadsUser.includes(:user).
        where(users:
              {company_id: company_id}).
        where(created_at: from_date..to_date)

      return CsvParser.get_downloads_users_csv_data(du)
    end
    private
      def calculate_date current_user
        i_day = current_user.company.enabled_date.day
        day = Date.today.day
        i_day <  day ?  Date.today.change(day: i_day) : Date.today.change(day: i_day).prev_month
      end
  end
end
