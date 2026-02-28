class Public::GenresController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    @genres = Genre.includes(:books)
  end

  def show
    @genre = Genre.find(params[:id])
    @books = @genre.books.where(is_deleted: false).includes(:genre, :subject, :user, :comments)
    @amount = @books.count
  end

end
