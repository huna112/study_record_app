class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  include PostsHelper
  include CommentsHelper
  
  private

    #ログインしているか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
end
