class ApplicationController < ActionController::Base
  before_action :authenticate, except: [:top] #未ログイン時はトップページしか閲覧不可

  def authenticate
    if user_signed_in?
      return true
    elsif admin_signed_in?
      return true
    else
      return false
    end
  end

end
