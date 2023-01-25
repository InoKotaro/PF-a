class Public::PostsController < ApplicationController
   before_action :authenticate_user!, only: [:show]
  before_action :is_matching_login_user, only: [:destroy] #ログイン中ユーザーのみアクセス可能ページ

  #index機能はhomes/topを使用

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params) #パラメータあり
    @post.user_id = current_user.id
    if @post.save
      redirect_to root_path #保存処理後は一覧へ遷移
    else
      render :new #保存失敗はnewページへ遷移
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path #一覧へ遷移
  end

  private

  def post_params
    params.require(:post).permit(:image, :title, :introduction)
  end

  #他ユーザーのアクセス制限
  def is_matching_login_user
    post_id = params[:id].to_i
    unless Post.find(post_id).user == current_user
      redirect_to root_path
    end
  end

end
