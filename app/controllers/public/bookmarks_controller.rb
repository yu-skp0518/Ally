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
    @book = Book.find(params[:id])
    @user = current_user
    @bookmark = @user.bookmarks.find_by(user_id: @user.id, book_id: @book.id)
    @bookmark.destroy
    redirect_to request.referer
  end

  def index
    @user = User.find(params[:user_id])
    @bookmarks = Bookmark.where(user_id: @user.id)
  end

end
