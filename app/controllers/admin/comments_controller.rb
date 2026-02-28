class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    @book = Book.find(params[:book_id])
    @comment = Comment.find_by(book_id: @book.id, id: params[:id])
    if @comment.destroy
      redirect_back fallback_location: admin_book_path(@book)
    else
      render 'admin/book#show'
    end
  end
end
