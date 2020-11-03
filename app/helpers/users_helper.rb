module UsersHelper
  def download_by_user user_id, layer
    u         = User.find(user_id)

    downloads = u.downloads_users.
      where('created_at::date =?', Date.today).
      sum(layer)
  end

  def accumulated_download_by_user user_id, layer
    u         = User.find(user_id)
    downloads = u.downloads_users.sum(layer)
  end

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

  def calculate_date
    i_day = current_user.company.enabled_date.day
    day = Date.today.day
    i_day <  day ?  Date.today.change(day: i_day) : Date.today.change(day: i_day).prev_month
  end

  def surplus_downloads user, layer
    acc     = accumulated_download_by_company user, layer
    surplus = 0

    total_downloads = case layer
                      when 'future_projects'
                        current_user.company.future_projects_downloads
                      when 'transactions'
                        current_user.company.transactions_downloads
                      when 'projects'
                        current_user.company.projects_downloads
                      end

    if acc > total_downloads
      surplus = acc - total_downloads
    end

    surplus
  end
end
