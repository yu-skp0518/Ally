class Public::BooksController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create, :edit, :update]

  def top
  end

  # 楽天ブックス検索
  def search
    if params[:keyword].present?
      @books = RakutenWebService::Books::Book.search(title: params[:keyword])
    else
      render :search
      flash[:notice] = "キーワードを入力してください。"
    end
  end

  # 検索後に結果選択の画面
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

    if @book.save
      flash[:create_success] = "新規投稿を作成しました！"
      redirect_to book_path(@book.id)
    else
      book = RakutenWebService::Books::Book.search(isbn: params[:book][:isbn]).first
      render :new
    end
  end

  def index
  end

  def show
    @book = Book.find(params[:id])
    @comment = Comment.new
    @comments = @book.comments.all.order(created_at: :desc).page(params[:page])
    @amount = @comments.count
    @amounts = @book.comments.all.count
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:success] = "変更内容を保存しました!"
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def disenable
    @book = Book.find(params[:book_id])
    @book.update(is_deleted: true)
    flash[:disenabled] = "投稿を削除しました!"
    redirect_to user_path(current_user)
  end

  private
  def book_params
    params.require(:book).permit(:isbn, :title, :author, :item_caption, :item_url, :publisher_name, :item_price, :large_image_url, :medium_image_url, :small_image_url, :story, :rate, :subject_id, :genre_id)
  end
end
