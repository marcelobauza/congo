class Admin::UsersController < Admin::DashboardsController

  layout 'admin'
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  include Admin::Users::Export

  # GET /users
  # GET /users.json
  def index
    if params[:role] == 'Flex'
      @users = User.get_users_by_filters(params).where(role_id: [6,15]).paginate(:page => params[:page], :per_page => 15)
    else
      @users = User.get_users_by_filters(params).paginate(:page => params[:page], :per_page => 15)
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user_counties = []
  end

  # GET /users/1/edit
  def edit
    @user_counties = @user.counties
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path(), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user_counties = @user.counties
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_user_path(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:complete_name, :password, :password_confirmation, :name, :email, :company_id, :city, :disabled, :role_id, :rut, :is_temporal, layer_types: [], county_ids: [], region_ids: [], flex_orders_attributes: [:id, :amount, :status])
  end
end
