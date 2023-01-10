class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top] #未ログイン時はトップページしか閲覧不可
end
