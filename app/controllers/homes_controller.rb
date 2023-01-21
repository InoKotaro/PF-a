class HomesController < ApplicationController

  def top
    @posts = Post.all.order(created_at: :desc).page(params[:page]) #投稿降順設定/ページネーション
  end

  def about
  end

end
