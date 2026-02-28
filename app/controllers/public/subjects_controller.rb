class Public::SubjectsController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    @subjects = Subject.includes(:books)
  end

  def show
    @subject = Subject.find(params[:id])
    @books = @subject.books.where(is_deleted: false).includes(:genre, :subject, :user, :comments)
    @amount = @books.count
  end
end
