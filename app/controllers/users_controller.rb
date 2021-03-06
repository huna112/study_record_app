class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :destroy]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end

  def index
    @user = current_user
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = current_user if logged_in?
    @user_signup = User.new
  end

  def create
    @user = current_user if logged_in?
    @user_signup = User.new(user_params)
    if @user_signup.save
      log_in @user_signup
      flash[:success] = "スタレコへようこそ！"
      redirect_to user_path(@user_signup)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy!
    flash[:success] = "ユーザは削除されました"
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit( :name, :email, :password,
                                    :password_confirmation, )
    end

    #管理者かどうか確認
    def admin_user
      unless current_user.admin?
        flash[:danger] = "管理者権限を持っていません"
        redirect_to(root_path)
      end
    end
end
