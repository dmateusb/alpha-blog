class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  def new
    @user = User.new()
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account infirmation was successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Welcome to the Alpha Blog #{@user.username}, you have successfully sing up"
      session[:user_id] = @user.id
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if current_user == @user
    flash[:notice] = "Account and all associated articles successfully deleted"
    redirect_to articles_path
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only edit your own account"
      redirect_to @user
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end