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
end
