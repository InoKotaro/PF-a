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

  #ゲストログイン
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    #検索機能
    get "search" => "searches#search"

    #ユーザー側ルート
    resources :users, only: [:show, :edit, :update] do

      #いいね一覧
      get :favorite_list, on: :collection

      #アカウント削除
      get "unsubscribe" => "users#unsubscribe", as: "confirm_unsubscribe" #論理削除
      patch "withdraw" => "users#withdraw", as: "withdraw_user" #論理削除

      #フォロー
      resource :relationships, only: [:create, :destroy] #フォロー機能ネスト化
        get 'followings' => 'relationships#followings', as: 'followings' #フォロー一覧
        get 'followers' => 'relationships#followers', as: 'followers'#フォロワー一覧
    end #users範囲終了

    #投稿
    resources :posts, only: [:new, :create, :show, :destroy] do
      resources :comments, only: [:create, :destroy] #コメント機能ネスト化
      resource :favorites, only: [:create, :destroy] #いいね機能ネスト化
    end #posts範囲終了

  end #public範囲終了

  #管理者側ルート
  namespace :admin do
    resources :users, only: [:index]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
