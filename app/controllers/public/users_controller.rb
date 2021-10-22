class Public::UsersController < ApplicationController
   before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @book = Book.find(params[:id])
    @books = Book.where(user_id: @user.id)
  end

  def confirm
  end

  def quit
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
     flash[:success] = "変更内容を保存しました!"
    redirect_to user_path(current_user)
    else
    render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :nick_name, :email, :profile, :profile_image)
  end

end
