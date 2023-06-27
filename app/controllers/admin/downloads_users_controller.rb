class Admin::DownloadsUsersController < ApplicationController
  layout 'admin'

  def index
    @users = User.select("id, name").order(:name).map { |u| [u.name, u.id]}

    @downloads_users = DownloadsUser
      .where.not(collection_ids: '{}')
      .by_user(params[:user_id])
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
    end
  end
end
