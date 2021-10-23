class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @books = Book.where(user_id: @user.id)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "変更内容を保存しました!"
      redirect_to admin_user_path(@user)
    else
      render :show
    end
  end

  private
  def user_params
    params.require(:user).permit(:is_valid)
  end
end
