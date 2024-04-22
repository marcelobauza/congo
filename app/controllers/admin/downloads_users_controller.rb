class Admin::DownloadsUsersController < ApplicationController
  layout 'admin'

  def index
    @users = User.select("id, name").order(:name).map { |u| [u.name, u.id] }
    @layer_types = [['CBR', 'transactions'], ['PRV', 'projects'], ['EM', 'future_projects']]

    @downloads_users = DownloadsUser
      .where.not(collection_ids: '{}')
      .by_user(params[:user_id])
      .by_layer_type(params[:layer_type])
      .disabled_only(params[:disabled_only] || false)
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 10)

    @disabled_only = params[:disabled_only].present?

    respond_to do |format|
      format.html
    end
  end

  def destroy
    downloads_user = DownloadsUser.find(params[:id])
    downloads_user.destroy
    redirect_to admin_downloads_users_path, notice: "El registro se ha eliminado correctamente."
  end

  def update_status
    downloads_users = DownloadsUser.where(id: params[:downloads_user_ids])

    if params[:commit] == "Deshabilitar"
      downloads_users.update_all(disabled: true)
      redirect_to admin_downloads_users_path, notice: "Los registros se han deshabilitado correctamente."
    else
      downloads_users.update_all(disabled: false)
      redirect_to admin_downloads_users_path, notice: "Los registros se han habilitado correctamente."
    end
  end
end
