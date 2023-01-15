class HomesController < ApplicationController

  def top
    @posts = Post.all
    @posts_page = Post.page(params[:page])
  end

  def about
  end

  

end
