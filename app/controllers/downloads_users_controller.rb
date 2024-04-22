class DownloadsUsersController < ApplicationController
  before_action :set_user, only: [:index]

  include Reports::FutureProjectsDataXls
  include Reports::ProjectsDataXls
  include Reports::TransactionsDataXls

  def index
    @downloads_users = DownloadsUser
      .where.not(collection_ids: '{}')
      .where(user_id: current_user.id)
      .by_layer_type(params[:layer_type])
      .disabled_only(false)
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 7)

    respond_to do |format|
      format.js
    end
  end

  def new
    @donwloads_users = DownloadsUser.new
  end

  def create
    ActiveRecord::Base.transaction do
      @downloads_users = DownloadsUser.new(downloads_users_params)
      filters          = JSON.parse(session[:data].to_json, {:symbolize_names => true})

      if filters && filters[:layer_type]
        if filters[:layer_type] == 'transactions_info'
          data = transactions_data filters

          if @message
            excel_data = @message
          else
            @downloads_users[:collection_ids] = data.ids
            @downloads_users[:transactions]   = data.count
            @downloads_users[:layer_type]     = 'transactions'

            @downloads_users.save!

            excel_data = transaction_data_xls.to_stream.read
          end
        elsif  filters[:layer_type] == 'future_projects_info'
          data = future_projects_data filters
          if @message
            excel_data = @message
          else
            @downloads_users[:collection_ids]  = data.ids
            @downloads_users[:future_projects] = data.count
            @downloads_users[:layer_type]      = 'future_projects'

            @downloads_users.save!

            excel_data = future_projects_data_xls.to_stream.read
          end
        elsif  filters[:layer_type] == 'projects_feature_info'
          data = projects_data filters
          if @message
            excel_data = @message
          else
            @downloads_users[:collection_ids] = data.flatten.map &:pim_id
            @downloads_users[:projects]   = data.flatten.uniq(&:code).count
            @downloads_users[:layer_type]      = 'projects'

            @downloads_users.save!

            excel_data = projects_data_xls.to_stream.read
          end
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.js { render json: { success: false, errors: @downlods_users.errors.full_messages }}
    end
  end

  def reports_by_layer
    layer    = DownloadsUser.find params[:id]
    filename = "#{layer.title}.xlsx"

    if layer.layer_type == 'transactions'
      @xl = Transaction.where(id: layer.collection_ids)

      excel_data = transaction_data_xls.to_stream.read
    elsif layer.layer_type == 'future_projects'
      @xl = FutureProject.where(id: layer.collection_ids)

      excel_data = future_projects_data_xls.to_stream.read
    elsif layer.layer_type == 'projects'
      @data = []
      @data << ProjectHomeReport.where(pim_id: layer.collection_ids)
      @data << ProjectDepartmentReport.where(pim_id: layer.collection_ids)

      excel_data = projects_data_xls.to_stream.read
    end

    send_data excel_data, filename: filename, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def future_projects_data filters
    data                    = FutureProject.reports(filters)
    total_downloads_allowed = current_user.company.future_projects_downloads || 0
    months                  = current_user.role.plan_validity_months
    layer                   = 'future_projects'

    ActiveRecord::Base.transaction do
      if months > 0
        row = allowed_downloads_by_plans layer, total_downloads_allowed, data
      else
        total_accumulated_downloads = current_user.downloads_users.where('created_at::date = ?', Date.today).sum(:future_projects)

        row = limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer
      end
    end
  end

  def projects_data filters
    total_downloads_allowed = current_user.company.projects_downloads || 0
    months                  = current_user.role.plan_validity_months
    layer                   = 'projects'
    @data                   = []

    (@project_homes, @project_departments = Project.reports(filters)).each do |project|
      codes = []
      data  = project

      codes << project.map(&:code).uniq if project.present?

      ActiveRecord::Base.transaction do
        if months > 0
          allowed_downloads_by_plans(layer, total_downloads_allowed, data, count: codes.count)
          @data << @xl
        else
          total_accumulated_downloads = current_user.downloads_users.where('created_at::date = ?', Date.today).sum(:projects)

          @data << limit_downloads(total_downloads_allowed, total_accumulated_downloads, data, layer)
        end
      end
    end

    @data
  end

  def transactions_data filters
    filters[:user_id]       = current_user.id
    data                    = Transaction.reports(filters)
    total_downloads_allowed = current_user.company.transactions_downloads || 0
    months                  = current_user.role.plan_validity_months
    layer                   = 'transactions'

    if months > 0
      row = allowed_downloads_by_plans layer, total_downloads_allowed, data
    else
      total_accumulated_downloads = current_user.downloads_users.where('created_at::date = ?', Date.today).sum(layer.to_sym)

      row = limit_downloads total_downloads_allowed, total_accumulated_downloads, data, layer
    end

    row
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
    params.require(:downloads_user).permit(:title, :transactions, :projects, :future_projects, :collection_ids).merge(user_id: current_user.id)
  end
end
