class Admin::DashboardsController < ApplicationController

  before_action :verify_admin
  layout 'admin'
  
  def index
  end
  
  private
  def verify_admin
    redirect_to root_url unless current_user.role.name == 'Admin' or current_user.role.name == 'Super admin'
  end
end
