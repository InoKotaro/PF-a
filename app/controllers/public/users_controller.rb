class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit]
  before_action :is_matching_login_user, only: [:edit, :update] #ログイン中ユーザーのみアクセス可能ページ
  before_action :ensure_guest_user, only: [:edit] #ゲストログインユーザーはユーザー編集ページへアクセス不可

  def show
    @user = User.find(params[:id])
    @posts= @user.posts #特定ユーザーの投稿分のみ格納
    @posts = @user.posts.order(created_at: :desc).page(params[:page]) #投稿降順/ページネーション
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params) #パラメータあり
      redirect_to user_path(@user)
    else
      render :edit #保存失敗はnewページへ遷移
    end
  end

  #いいね一覧
  def favorite_list
    favorite = Favorite.where(user: current_user).pluck(:post_id)
    @favorite_list = Post.find(favorite)
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

  #退会処理
  def withdraw
    @user = User.find(params[:user_id])
    @user.update(is_valid: false) #falseに変更して退会済扱いにする
    reset_session
    redirect_to root_path
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

  #ゲストログインユーザー判別
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "ゲスト"
      redirect_to user_path(current_user)
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
