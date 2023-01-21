class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:index, :edit, :update, :destroy] #ログイン中ユーザーのみアクセス可能ページ
  before_action :is_matching_admin_user, only: [:index] #管理者のみアクセス可能ページ
  before_action :ensure_guest_user, only: [:edit] #ゲストログインユーザーはユーザー編集ページへアクセス不可

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts= @user.posts #特定ユーザーの投稿分のみ格納
    @posts = @user.posts.page(params[:page]) #ページネーション
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params) #パラメータあり
    redirect_to user_path(@user)
  end

  #いいね一覧
  def favorite_list
    favorites = Favorite.where(user: current_user).pluck(:post_id)
    @favorite_list = Post.find(favorites)
  end

  #-----------------フォロー機能↓------------------
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
  #------------------------------------------------

  #退会画面
  def unsubscribe
    @user = current_user
  end

  #退会処理
  def withdraw
    @user = User.find(params[:user_id])
    @user.update(is_valid: false) #falseに変更して退会済扱いにする
    reset_session
    redirect_to root_path, alert: "ご利用ありがとうございました。"
  end

  private

  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction)
  end

  #ログイン中ユーザー判別
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to root_path
    end
  end

  #管理者判別
  def is_matching_admin_user
    unless admin_signed_in?
      redirect_to root_path
    end
  end

  #ゲストログインユーザー判別
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
