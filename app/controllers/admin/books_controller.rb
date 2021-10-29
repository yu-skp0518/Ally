class Admin::BooksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @comments = @book.comments.all.order(created_at: :desc).page(params[:page])
    @amount = @comments.count
    @amounts = @book.comments.all.count
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:success] = "変更内容を保存しました!"
      redirect_to book_path(@book)
    else
      render :edit
    end
  end
end
