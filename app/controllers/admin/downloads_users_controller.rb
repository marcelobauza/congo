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

  def delete
    DownloadsUser.where(id: params[:downloads_user_ids]).destroy_all

    redirect_to admin_downloads_users_path, notice: "Los registros se han eliminado correctamente."
  end
end
