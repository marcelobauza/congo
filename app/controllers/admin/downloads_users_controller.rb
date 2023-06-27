class Admin::DownloadsUsersController < ApplicationController
  layout 'admin'
  before_action :set_user, only: [:index]

  def index
    @downloads_users = DownloadsUser
      .where(user_id: @user.id)
      .where.not(collection_ids: '{}')
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
    end
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end
end
