class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  
  def logged_in?
    return false if current_user.nil?
    current_user.session_token == session[:session_token]
  end

  def current_user
    @currentuser ||= User.find_by_session(session[:session_token])
    @currentuser
  end

  def login!(user)
    session[:session_token]=user.reset_session_token!
    user.save!
  end

  def logout!
   @currentuser = current_user
   return nil if @currentuser.nil?
   @currentuser.reset_session_token!
   session[:session_token] = nil
  end
end
