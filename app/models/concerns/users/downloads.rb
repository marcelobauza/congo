module Users::Downloads
  extend ActiveSupport::Concern

  module ClassMethods
    def accumulated_download_by_company user, layer
      u = User.find(user)

      from_date = calculate_date u
      to_date   = from_date.next_month

      DownloadsUser.includes(
        :user
      ).where(
        users: {company_id: u.company_id}
      ).where(
        created_at: from_date..to_date
      ).sum(layer)
    end

    def calculate_date user
      i_day = user.company.enabled_date.day
      day = Date.today.day
      i_day <  day ?  Date.today.change(day: i_day) : Date.today.change(day: i_day).prev_month
    end
  end
end