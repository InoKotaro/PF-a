class Admin::UsersController < ApplicationController
  before_action :is_matching_admin_user, only: [:index] #管理者のみアクセス可能ページ

  def index
    @users = User.all.page(params[:page])
  end

  private

  #管理者判別
  def is_matching_admin_user
    unless admin_signed_in?
      redirect_to root_path
    end
  end

end
