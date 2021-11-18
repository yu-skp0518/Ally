class Public::GenresController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    @genres = Genre.all
  end

  def show
    @genre = Genre.find(params[:id])
    @books = @genre.books.where(is_deleted: false)
    @amount = @genre.books.where(is_deleted: false).count
  end

end
