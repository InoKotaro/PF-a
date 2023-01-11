class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page])  #特定ユーザーの全投稿を変数に格納/
                                              #多側を取得するのでテーブル名複数形表記
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params) #パラメータあり
    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction)
  end

end
