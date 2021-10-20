class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.book_id = @book.id
    if @comment.save
      redirect_to book_path(@book.id)
    else
      render 'public/books/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy(comment_params)
      redirect_to request.referer
    else
      render 'public/book#show'
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
