class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.book_id = @book.id
    @comment.score = fetch_sentiment_score(comment_params[:body])
    if @comment.save
      redirect_to book_path(@book.id)
      flash[:notice] = "コメントが投稿されました。"
    else
      redirect_back fallback_location: book_path(@book)
      flash[:alert] = "コメントの投稿に失敗しました。"
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = Comment.find_by(book_id: @book.id, id: params[:id])
    if @comment.destroy
      redirect_back fallback_location: book_path(@book)
    else
      @book = Book.find(params[:book_id])
      @comments = @book.comments.all.order(created_at: :desc).page(params[:page])
      redirect_back fallback_location: book_path(@book)
    end
  end

  private
  def fetch_sentiment_score(body)
    return nil if body.blank? || ENV['GOOGLE_API_KEY'].blank?
    Language.get_data(body)
  rescue JSON::ParserError, StandardError
    nil
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
