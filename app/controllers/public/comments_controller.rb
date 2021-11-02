class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.book_id = @book.id
    @comment.score = Language.get_data(comment_params[:body])
    if @comment.save
      redirect_to book_path(@book.id)
      flash[:notice] = "コメントが投稿されました。"
    else
      render 'public/books/show'
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = Comment.find_by(book_id: @book.id, id: params[:id])
    if @comment.destroy
      redirect_to request.referer
    else
      render 'public/book#show'
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
