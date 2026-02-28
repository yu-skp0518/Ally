class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @user = current_user
    @bookmark = @user.bookmarks.new(user_id: @user.id, book_id: @book.id)
    @bookmark.save
    redirect_to request.referer
  end

  def destroy
    @book = Book.find(params[:book_id])
    @user = current_user
    @bookmark = @user.bookmarks.find_by(user_id: @user.id, book_id: @book.id)
    @bookmark.destroy
    redirect_to request.referer
  end

  def index
    return redirect_to root_path, alert: "権限がありません" unless params[:user_id].to_i == current_user.id
    @user = current_user
    @bookmarks = Bookmark.where(user_id: @user.id).includes(book: [:genre, :subject, :user, :comments])
  end

end
