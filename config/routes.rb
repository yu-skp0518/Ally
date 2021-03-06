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
    # アプリ内での楽天ブックス検索用
    get 'books/search'
    # お問い合わせ用
    get 'inquiries/new'
    # アプリ内での投稿検索用
    get 'searches/search'

    resources :genres, only: [:index, :update, :show]
    resources :subjects, only: [:index, :update, :show]

    resources :books, except: [:destroy] do
      patch 'disenable'
      resources :bookmarks, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy] do
        resources :likes, only: [:create, :destroy]
      end
    end

    resources :users, only: [:show, :edit, :update, :destroy] do
        get 'confirm'
        patch 'quit'
        patch 'unban'
      resources :relationships, only: [:create, :destroy]
        get 'relationships/followings', as: 'followings'
        get 'relationships/followers', as: 'followers'

      resources :inquiries, only: [:create, :update]
      resources :likes, only: [:index]
      resources :bookmarks, only: [:index]
    end
  end

  # 管理側
  namespace :admin do
    get 'searches/search'

    resources :genres, only: [:index, :show, :create]
    resources :subjects, except: [:new]
    resources :books, only: [:show, :update] do
      resources :comments, only: [:index, :destroy]
    end

    resources :users, only: [:index, :show, :update] do
      resources :inquiries, only: [:index, :show, :update]
        get 'relationships/followings'
        get 'relationships/followers'
    end
  end

end
