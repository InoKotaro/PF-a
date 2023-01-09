class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params) #パラメータ有り
    @post.user_id = current_user.id
    @post.save
    redirect_to posts_path #一覧へ遷移
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path #一覧へ遷移
  end

  private

  def post_params
    params.require(:post).permit(:image, :title, :introduction)
  end

end
