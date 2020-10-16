class ApplicationController < ActionController::Base
  helper_method :require_any_logged_in
  helper_method :require_this_logged_in

  def login!(user)
    session[:session_token] = user.session_token
    @current_user = user
  end
  
  def logout!
    session[:session_token] = nil
    current_user.try(:reset_session_token)
  end
  
  def user_logged_in?
    ! session[:session_token].nil?
  end
  
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def require_any_logged_in
    redirect_to login_path, notice: "Must log in first" unless session[:session_token]
  end
  
  def require_this_logged_in
    redirect_to root_path, notice: "Mind your own business" unless current_user.id == params[:id].to_i
  end
  
end
