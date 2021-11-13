class Flex::RegistrationsController < Devise::RegistrationsController
  layout "new_registration", only: [:new, :create]

  private

  def sign_up_params
    params.require(:user).permit(:name, :complete_name, :email, :password, :password_confirmation, :rut).merge(role_id: 15, company_id: 52)
  end
end
