class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  #before_action :set_paper_trail_whodunnit
  layout :layout_by_resource


  def layout_by_resource
    if devise_controller? and
        resource_name == :user and
        action_name == 'new'
      "login"
    else
      "application"
    end
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end



end
