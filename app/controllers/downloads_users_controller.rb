class DownloadsUsersController < ApplicationController
  before_action :set_user, only: [:index]

  def index
    @downloads_users = DownloadsUser
      .where(user_id: @user.id)
      .where.not(collection_ids: '{}')
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.js
    end
  end

  def new
    @donwloads_users = DownloadsUser.new
  end

  def create
    ActiveRecord::Base.transaction do
      @donwloads_users = DownloadsUser.new(downloads_users_params)
    end
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end

  def transactions_data
    filters                 = JSON.parse(session[:data].to_json, {:symbolize_names => true})
    filters[:user_id]       = current_user.id
    data                    = Transaction.reports(filters)
    total_downloads_allowed = current_user.company.transactions_downloads || 0
    months                  = current_user.role.plan_validity_months
    layer                   = 'transactions'


    if months > 0
      allowed_downloads_by_plans layer, total_downloads_allowed, data
    else
      total_accumulated_downloads = current_user.downloads_users.where('created_at::date = ?', Date.today).sum(layer.to_sym)

      limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer
    end

    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Datos_Compraventas.xlsx"'
      }
    end
  end

  def allowed_downloads_by_plans layer, total_downloads_allowed, data, count: nil
    from_date         = current_user.company.enabled_date
    to_date           = from_date + current_user.role.plan_validity_months.months
    allowed_downloads = (from_date..to_date).include? Date.today

    if allowed_downloads
      total_accumulated_downloads = User.accumulated_download_by_company current_user.id, layer

      limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer, count: nil
    else
      @message = "No tiene plan permitido"
    end
  end

  def limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer, count: nil
    total_downloads = total_downloads_allowed - total_accumulated_downloads
    ids             = []

    if total_downloads > 0
      limit = if count
                count <= total_downloads ? data.count : total_downloads
              else
                data.count <= total_downloads ? data.count : total_downloads
              end

      @xl = data.limit(limit)

      if layer == 'projects'
        ids << @xl.map(&:pim_id) if @xl.present?
      else
        ids << @xl.ids
      end
      @xl
    else
      @message = "Ha superado el límite de descarga"
    end
  end

  def downloads_users_params
    params.require(:downloads_user).permit(:title).merge(user_id: current_user.id)
  end

end
