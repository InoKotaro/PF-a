class Public::FavoritesController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id) #外部キー(post_id)指定
    favorite.save
    redirect_to post_path(post) #非同期化に伴い不要
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id) #外部キー(post_id)指定
    favorite.destroy
    redirect_to post_path(post) #非同期化に伴い不要
  end

end