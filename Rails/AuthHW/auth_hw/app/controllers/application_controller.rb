class ApplicationController < ActionController::Base
  helper_method :user_logged_in?
  helper_method :current_user

  def login!(user)
    session[:session_token] = user.session_token
    @current_user = user
  end

  def user_logged_in?
    current_user
  end
  
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def logout!
    current_user.try(:reset_session_token)
    session[:session_token] = nil
  end

  def require_user_logged_in
    redirect_to login_path if current_user.nil?
  end

  def require_this_user
    redirect_to root_path, notice: "must be logged in" unless current_user
    redirect_to root_path, notice: "mind your business" unless current_user.id == params[:id].to_i
  end
  
end
