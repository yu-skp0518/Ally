Rails.application.routes.draw do

  # ユーザー側のデバイス
  devise_for :user, controllers: {
    sessions: 'public/sessions',
    passwords: 'public/passwords',
    registrations: 'public/registrations'
  }

  # 管理側のデバイス
  devise_for :admin, controllers: {
    sessions: 'admin/sessions',
    passwords: 'admin/passwords',
    registrations: 'admin/registrations'
  }

  # ユーザー側
  scope module: :public do

    root to: 'books#top'
    resources :books
      # 楽天APIでの蔵書検索用
      get 'books/search'

    resources :inquiries, only: [:new, :create, :update]
    resources :genres, only: [:index, :update]
    resources :subjects, only: [:index, :update]

    resources :relationships, only: [:create, :destroy]
      get 'relationships/followings'
      get 'relationships/followers'

    resources :bookmarks, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:index, :create, :destroy]
    resources :users, only: [:show, :edit, :update]
      get 'users/confirm'
      patch 'users/quit'

  end

  # 管理側
  namespace :admin do

    resources :books, only: [:index, :show, :update]
    resources :inquiries, only: [:index, :show, :update]
    resources :genres, except: [:new, :show, :destroy]
    resources :subjects, except: [:new, :show]

      get 'relationships/followings'
      get 'relationships/followers'

    resources :comments, only: [:index, :destroy]
    resources :users, only: [:index, :show, :update]

  end

end
