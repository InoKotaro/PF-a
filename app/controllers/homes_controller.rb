class HomesController < ApplicationController

  def top
    @posts = Post.all
    @posts_page = Post.page(params[:page]).per(3) #ページネーション
  end

  def about
  end

end
