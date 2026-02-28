class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.includes(:books).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @books = Book.where(user_id: @user.id).includes(:user, :genre, :subject, :comments)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # ステータス更新と共に紐づいた投稿も削除or有効にする
      if @user.is_valid == true
        @user.books.update(is_deleted: false)
      else
        @user.books.update(is_deleted: true)
      end
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
