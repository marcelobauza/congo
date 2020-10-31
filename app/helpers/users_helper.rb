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

    DownloadsUser.includes(
      :user
    ).where(
      users: {company_id: u.company_id}
    ).where(
      created_at: Date.today.beginning_of_month..Date.today.end_of_month
    ).sum(layer)
  end
end
