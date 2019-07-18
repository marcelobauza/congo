class DownloadsController < ApplicationController
  before_action :filters

  def index
  end

  def transactions_csv 
    @transactions = Transaction.download_csv(@filters)
    respond_to do |format|
      format.csv { send_data @transactions.to_csv }
    end
  end

  def projects_csv
    @projects = Project.download_csv(@filters)
    respond_to do |format|
      format.csv { send_data @projects.to_csv }
    end
  end

  private
  def filters
    @filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
  end

end
