class Flex::RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :rut).merge(role_id: 15, company_id: 52)
  end

end
