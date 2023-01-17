class HomesController < ApplicationController

  def top
    p "=========================================="
    p params[:page]
    @posts = Post.all
    @posts_page = Post.page(params[:page]) #ページネーション
  end

  def about
  end

end
