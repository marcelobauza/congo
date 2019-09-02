class Admin::UsersController < ApplicationController
  
  layout 'admin'
  before_action :set_user, only: [:show, :edit, :update, :destroy]

    
  # GET /users
  # GET /users.json
  def index
    @users = User.get_users_by_filters(params).paginate(:page => params[:page], :per_page => 15)
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
    if params[:user][:county_ids].lenght > 0 
      params[:user][:county_ids].each do |county_id|
        CountiesUser.create(county_id: county_id, user_id: @user.id)
      end
    end
    
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
    if params[:user][:county_ids].length > 0
      @counties_users = CountiesUser.where(user_id: @user.id)
      @counties_users.destroy_all if  !@counties_users.nil?
            params[:user][:county_ids].each do |county_id|
        CountiesUser.create(county_id: county_id, user_id: @user.id)
      end
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
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
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
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
      params.require(:user).permit(:complete_name, :password, :password_confirmation, :name, :email, :company, :city, :disabled, :role_id, :rut, :is_temporal,  counties_users_attributes: [:county_id, :user_id] )
    end
end
