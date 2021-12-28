module Users::Accumulated
  extend ActiveSupport::Concern

  def accumulated_download_by_company user, layer
    u = User.find(user)

    from_date = calculate_date
    to_date   = from_date.next_month

    DownloadsUser.includes(
      :user
    ).where(
      users: {company_id: u.company_id}
    ).where(
      created_at: from_date..to_date
    ).sum(layer)
  end
end
