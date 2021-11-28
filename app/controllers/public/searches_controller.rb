class Public::SearchesController < ApplicationController

  def search
    @keyword = params[:keyword]
    @how = params[:how]
    @model = params[:model]
    @datas = search_for(@how, @model, @keyword)
  end

private

  def match(model, keyword)
    if model == 'user'
      User.where(name: keyword)
    elsif model == 'book'
      Book.where(title: keyword)
    end
  end

  def partical(model, keyword)
    if model == 'user'
      User.where('nick_name LIKE ?', "%#{keyword}%")
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