class Public::SubjectsController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    @subjects = Subject.all
    @subject = Subject.new
  end

  def show
    @subject = Subject.find(params[:id])
    @books = @subject.books.all
    @amount = @subject.books.count
  end
end
