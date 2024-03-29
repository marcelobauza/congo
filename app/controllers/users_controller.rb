class UsersController < ApplicationController
  before_action :set_user, only: [:account, :update]

  def account
    respond_to do |format|
      format.js
    end
  end

  def update
    @errorMessage = []


    respond_to do |format|
     if @user.update(user_params)
      bypass_sign_in(@user)
      format.js
      else
      format.js
      @user.errors.any?
      @user.errors.each do |key, value|
        @errorMessage.push(value)
      end
    end
    end
  end

  def export_csv_downloads_by_company
    company = current_user.company
    data    = DownloadsUser.export_csv_downloads_by_company company, 'month', current_user

    send_file data, :type => 'text/csv', :disposition => "inline", :filename => "Descargar_por_empresa.csv"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:complete_name, :password, :password_confirmation, :name, :city)
    end
end
