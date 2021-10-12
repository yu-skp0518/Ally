Rails.application.routes.draw do

  devise_for :user, controllers: {
    sessions: 'public/sessions',
    passwords: 'public/passwords',
    registrations: 'public/registrations'
  }

  devise_for :admin, controllers: {
    sessions: 'admin/sessions',
    passwords: 'admin/passwords',
    registrations: 'admin/registrations'
  }

  root to: 'public/books#top'

    get 'books/top'
    get 'books/search'
    get 'books/create'
    get 'books/new'
    get 'books/create'
    get 'books/index'
    get 'books/show'
    get 'books/edit'
    get 'books/upddate'

  namespace :admin do
    get 'books/index'
    get 'books/show'
    get 'books/update'
  end

end
