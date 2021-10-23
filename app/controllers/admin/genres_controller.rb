class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genres = Genre.all
    @genre = Genre.new
  end

  def create
    @genres = Genre.all
    @genre = Genre.new(genre_params)
    if @genre.save
       @genres = Genre.all
       redirect_to admin_genres_path
    else
      @genres = Genre.all
      render 'admin/genre#index'
    end
  end

  def show
    @genre = Genre.find(params[:id])
    @books = @genre.books.all
    @amount = @genre.books.count
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to admin_genres_path
    else
      render 'admin/genre#edit'
    end
  end

  def destroy
  end

  private
  def genre_params
    params.require(:genre).permit(:name)
  end
end
