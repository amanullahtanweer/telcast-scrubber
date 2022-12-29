class Admin::UsersController < Admin::AdminController
	before_action :set_user, only: %i[show edit update destroy]

	def index
		@users = params[:q] ? User.all : User.all
    @q = @users.ransack(params[:q])
    if request.xhr?
      respond_to do |format|
          format.json {
              render json: User.where(id: params[:user_id]).first
          }
      end
    end
  end

  def show
    redirect_to edit_admin_user_path(@user)
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to edit_admin_user_path(@user), notice: 'User was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)

      if @user.previous_changes.key?('max_sessions')
        sippy    = SippyApi.new({action: "update_max_sessions", account_id: @user.i_account, user: @user})
        result = sippy.update_account({i_account: @user.i_account.to_i, max_sessions: @user.max_sessions.to_i})
      end
      redirect_to edit_admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end



  private

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    params.require(:user).permit(:name, :phone, :password, :password_confirmation, :company, :email, :is_active )
  end


  def set_user 
    @user = User.find(params[:id])
  end

end
