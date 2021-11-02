class Public::UsersController < ApplicationController
   before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @books = Book.where(user_id: @user.id).order(created_at: :desc)
    @comments = Comment.joins(:likes).where(likes: {user_id: params[:id]})
  end

  def quit
    @user = current_user
    @user.update(is_valid: false)
    reset_session
    redirect_to root_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
     flash[:success] = "変更内容を反映しました。"
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def unban
    @user = User.find(params[:user_id])
    @user.update(is_valid: true)
    flash[:re_enabled] = "アカウントを再度有効にしました!"
    redirect_to user_path(current_user)
  end

  def destroy
    reset_session
    redirect_to new_user_registration_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :nick_name, :email, :profile, :profile_image, :is_valid)
  end

end
