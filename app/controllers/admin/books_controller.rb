class Admin::BooksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @books = Book.includes(:user, :genre, :subject).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @book = Book.includes(:user, :genre, :subject).find(params[:id])
    @comments = @book.comments.includes(:user, :likes).order(created_at: :desc).page(params[:page])
    @amounts = @book.comments.count
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:success] = "変更内容を保存しました!"
      redirect_to admin_book_path(@book)
    else
      render :show
    end
  end

  private

  def book_params
    params.require(:book).permit(:is_deleted, :story, :rate, :title, :author, :item_caption, :item_url, :publisher_name, :item_price, :large_image_url, :medium_image_url, :small_image_url, :subject_id, :genre_id)
  end
end
