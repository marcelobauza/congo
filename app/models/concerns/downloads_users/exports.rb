module DownloadsUsers::Exports
  extend ActiveSupport::Concern

  module ClassMethods
    def export_csv_downloads_by_company company, option, user
      from_date = company.enabled_date
      to_date   = from_date + user.role.plan_validity_months.months

      du = DownloadsUser.includes(:user).
        where(users:
              {company_id: company.id}).
      where(created_at: from_date..to_date)

      return CsvParser.get_downloads_users_csv_data(du)
    end

    private

    def calculate_date company, option
      if company.enabled_date.nil?
        [Date.today.prev_month, Date.today]
      else
        i_day = company.enabled_date.day
        day   = Date.today.day

        if option == 'year'
          [Date.today.prev_year, Date.today]
        else
          from_date = if i_day <  day
                        Date.today.change(day: i_day)
                      else
                        Date.today.change(day: i_day).send("prev_#{option}")
                      end

          to_date = from_date.next_month

          [from_date, to_date]
        end

      end
    end
  end
end
