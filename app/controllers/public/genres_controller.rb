class Public::GenresController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    @genres = Genre.all
    @genre = Genre.new
  end

  def show
    @genre = Genre.find(params[:id])
    @books = @genre.books.all
    @amount = @genre.books.count
  end

  # def update
  #   @genre = Genre.find(params[:id])
  #   if @genre.update(genre_params)
  #     @genres = Genre.all
  #     redirect_to genres_path
  #   else
  # end
end
