class Public::BooksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update]

  def top
  end

  def search
    if params[:keyword]
      @books = RakutenWebService::Books::Book.search(title: params[:keyword])
    end
  end

  def new
    book = RakutenWebService::Books::Book.search(isbn: params[:isbn]).first
    @book = Book.new(
      isbn: book.isbn,
      small_image_url: book.small_image_url,
      medium_image_url: book.medium_image_url,
      large_image_url: book.large_image_url,
      title: book.title,
      author: book.author,
      item_caption: book.item_caption,
      publisher_name: book.publisher_name,
      item_price: book.item_price,
      item_url: book.item_url,
    )
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    
    # 以下の2つは取り急ぎseedsに保存したデータで応急処置
    @book.genre_id = Genre.first.id
    @book.subject_id = Subject.first.id

    if @book.save(book_params)
      flash[:notice] = "新規投稿を作成しました！"
      redirect_to book_path(@book.id)
    else
      book = RakutenWebService::Books::Book.search(isbn: @book.isbn).first
      render :new
    end
  end

  def index
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit
  end

  def update
  end

  private
  def book_params
    params.require(:book).permit(:isbn, :title, :author, :item_caption, :item_url, :publisher_name, :item_price, :large_image_url, :medium_image_url, :small_image_url, :story, :rate,)
  end
end
