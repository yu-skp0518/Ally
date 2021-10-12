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
    get 'books/search'
  end

  # 管理側
  namespace :admin do
    resources :books, only: [:index, :show, :update]
  end

end
