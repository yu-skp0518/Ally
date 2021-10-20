class Public::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    # @book = Book.find(params[:book_id])
    @comment = Comment.find(params[:comment_id])
    @like = @comment.likes.new(user_id: current_user.id, comment_id: params[:comment_id])
    @like.save
    redirect_to request.referer
  end

  def destroy
    # @book = Book.find(params[:book_id])
    @comment = Comment.find(params[:comment_id])
    @like = @comment.likes.find_by(user_id: current_user.id, comment_id: params[:comment_id])
    @like.destroy
    redirect_to request.referer
  end
end
