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
    # ルートパス
    root to: 'books#top'
    # 楽天APIでの蔵書検索用
    get 'books/search'

    resources :genres, only: [:index, :update]
    resources :subjects, only: [:index, :update]

    resources :books do
      resources :comments, only: [:index, :create, :destroy]
    end

    resources :users, only: [:show, :edit, :update] do
        get 'users/confirm'
        patch 'users/quit'

      resources :relationships, only: [:create, :destroy]
        get 'relationships/followings'
        get 'relationships/followers'

      resources :bookmarks, only: [:create, :destroy]
      resources :likes, only: [:create, :destroy]
      resources :inquiries, only: [:new, :create, :update]
    end

  end

  # 管理側
  namespace :admin do

    resources :genres, except: [:new, :show, :destroy]
    resources :subjects, except: [:new, :show]

    resources :books, only: [:index, :show, :update] do
      resources :comments, only: [:index, :destroy]
    end

    resources :users, only: [:index, :show, :update] do
      resources :inquiries, only: [:index, :show, :update]
        get 'relationships/followings'
        get 'relationships/followers'
    end

  end

end
