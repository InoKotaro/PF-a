Rails.application.routes.draw do

  root to: "homes#top"
  get "/about" => "homes#about", as: "about"

  #---------------------ユーザー↓-----------------------------

  #ユーザーデバイス認証用
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  #ユーザー側ルート
  scope module: :public do
    resources :users, only: [:show, :edit, :update]
    resources :posts, only: [:new, :create, :index, :show, :destroy]
  end

  #----------------------管理者↓-----------------------------

  #管理者デバイス認証用
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  #管理者側ルート
  namespace :admin do
    get "/" => "homes#top"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
