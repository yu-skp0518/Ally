class Public::SearchesController < ApplicationController

  def search
    if params[:keyword].present?
      @keyword = params[:keyword]
      @how = params[:how]
      @model = params[:model]
      @datas = search_for(@how, @model, @keyword)
      if @model == 'user'
        @book = Book.where(user_id: @datas.ids, is_deleted: false).last
      end
    else
      redirect_back fallback_location: root_path
    end
  end

private

  def match(model, keyword)
    if model == 'user'
      User.where(nick_name: keyword).or(User.where(name: keyword)).where.not(id: current_user.id)
    elsif model == 'book'
      Book.where(title: keyword)
    end
  end

  def partical(model, keyword)
    if model == 'user'
      User.where('nick_name LIKE ?', "%#{keyword}%").or(User.where('name LIKE ?', "%#{keyword}%")).where.not(id: current_user.id)
    elsif model == 'book'
      Book.where('title LIKE ?', "%#{keyword}%")
    end
  end

  def search_for(how, model, keyword)
    case how
    when 'match'
      match(model, keyword)
    when 'partical'
      partical(model, keyword)
    end
  end

end