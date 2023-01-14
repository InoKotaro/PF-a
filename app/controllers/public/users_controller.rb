class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts= @user.posts #特定ユーザーの投稿分のみ格納
    @posts_page = @user.posts.page(params[:page]) #ページネーション
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

  private

  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction)
  end

  #他ユーザーのアクセス制限
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to posts_path
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
