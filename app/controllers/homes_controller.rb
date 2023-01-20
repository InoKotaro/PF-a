class HomesController < ApplicationController

  def top
    @posts = Post.all.page(params[:page]) #ページネーション
  end

  def about
  end

end
