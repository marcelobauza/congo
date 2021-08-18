class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  #before_action :set_paper_trail_whodunnit
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    if current_user.role.name == 'Flex'
      flex_root_path()
    else
      root_path()
    end
  end

  def layout_by_resource
    if devise_controller? and
        resource_name == :user and
        action_name == 'new'
      "login"
    else
      if current_user.role.name == 'Flex'
        'flex'
      else
        "application"
      end
    end
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end
end
