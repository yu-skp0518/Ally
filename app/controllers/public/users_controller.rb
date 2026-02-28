class Public::UsersController < ApplicationController
   before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @books = Book.where(user_id: @user.id, is_deleted: false).includes(:comments).order(created_at: :desc)
    @comments = @user.liked_comments.order(created_at: :desc)
  end

  def quit
    @user = current_user
    @user.update(is_valid: false)
    @user.books.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  def edit
    return redirect_to root_path, alert: "権限がありません" unless params[:id].to_i == current_user.id
    @user = User.find(params[:id])
  end

  def update
    return redirect_to root_path, alert: "権限がありません" unless params[:id].to_i == current_user.id
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
    @user.books.update(is_deleted: false)
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
