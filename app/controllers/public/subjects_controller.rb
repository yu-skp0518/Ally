class Public::SubjectsController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    @subjects = Subject.all
  end

  def show
    @subject = Subject.find(params[:id])
    @books = @subject.books.where(is_deleted: false)
    @amount = @subject.books.where(is_deleted: false).count
  end
end
