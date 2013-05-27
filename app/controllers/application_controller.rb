class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin
    redirect_to new_user_session_path
  end
end
