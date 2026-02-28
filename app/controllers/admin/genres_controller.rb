class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genres = Genre.includes(:books)
    @genre = Genre.new
  end

  def create
    @genres = Genre.includes(:books)
    @genre = Genre.new(genre_params)
    if @genre.save
       @genres = Genre.includes(:books)
       redirect_to admin_genres_path
    else
      @genres = Genre.includes(:books)
      flash[:failure] = "投稿に失敗しました"
      render 'admin/genre#index'
    end
  end

  def show
    @genre = Genre.find(params[:id])
    @books = @genre.books.includes(:user, :genre, :subject, :comments)
    @amount = @books.count
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
