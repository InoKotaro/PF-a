Rails.application.routes.draw do

  root to: "homes#top"
  get "/about" => "homes#about", as: "about"

  #---------------------デバイス↓-----------------------------
  #ユーザーデバイス認証用
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  #管理者デバイス認証用
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
   #----------------------------------------------------------

  #ユーザー側ルート
  scope module: :public do

    get "search" => "searches#search" #検索機能
    resources :users, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy] #フォロー機能ネスト化
      get 'followings' => 'relationships#followings', as: 'followings' #フォロー一覧
      get 'followers' => 'relationships#followers', as: 'followers'#フォロワー一覧
      get :favorite_list, on: :collection  #いいね一覧
      get "unsubscribe/:name" => "homes#unsubscribe", as: "confirm_unsubscribe" #論理削除
      patch ":id/withdraw/:name" => "homes#withdraw", as: "withdraw_user" #論理削除
      put "withdraw/:name" => "users#withdraw" #論理削除

    end

    resources :posts, only: [:new, :create, :show, :destroy] do
      resources :comments, only: [:create, :destroy] #コメント機能ネスト化
      resource :favorites, only: [:create, :destroy] #いいね機能ネスト化
    end
  end

  #管理者側ルート
  namespace :admin do
    get "/" => "homes#top"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
