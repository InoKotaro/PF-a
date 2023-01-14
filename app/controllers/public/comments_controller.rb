class Public::CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = Comment.new(comment_params) #パラメータ有り
    comment.user_id = current_user.id #外部キー(user_id)指定
    comment.post_id = post.id #外部キー(post_id)指定
    comment.save
    redirect_to post_path(post)
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  def show
    @comment = Comment.new
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
