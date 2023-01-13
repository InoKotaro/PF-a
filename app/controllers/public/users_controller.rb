class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :set_user, only: [:followings, :followers]

  def show
    @user = User.find(params[:id])
    @posts_page = @user.posts.page(params[:page]) #特定ユーザーの全投稿を変数に格納/
                                                  #多側を取得するのでテーブル名複数形表記
    @posts= @user.posts #特定ユーザーの投稿分のみ格納
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params) #パラメータあり
    redirect_to user_path(@user)
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

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

end
