class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params) #パラメータ
    @post.user_id = current_user.id
    if @post.save
      redirect_to root_path #保存処理後は一覧へ遷移
    else
      render :new #保存失敗はnewページへ遷移
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
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
