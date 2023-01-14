class HomesController < ApplicationController

  def top
    @posts = Post.all
    @posts_page = Post.page(params[:page])
  end

  def about
  end

  def unsubscribe #退会画面
    @user = current_user
  end

  def withdraw #退会処理
    @user = User.find(params[:id])
    @user.update(is_valid: false) #falseに変更して退会済扱いにする
    reset_session
    redirect_to root_path, alert: "ご利用ありがとうございました。"
  end

end
