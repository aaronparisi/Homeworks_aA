class ApplicationController < ActionController::Base
  helper_method :user_logged_in?
  helper_method :current_user
  helper_method :logging_in?
  helper_method :signing_up?
  # helper_method :require_any_logged_in
  # helper_method :require_this_logged_in
  # these are only used in controllers, not views
  before_action :current_user

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

  def require_logged_out
    redirect_to root_path, notice: "Logout before creating a new user" unless ! user_logged_in?
  end

  def require_band_membership
    unless Band.find(params[:band_id]).has_member?(current_user)
      redirect_to root_path, notice: "Only band members can do that"
    end
  end
  
  def logging_in?
    params[:controller] == 'sessions' && params[:action] == 'new'
  end
  
  def signing_up?
    params[:controller] == 'users' && params[:action] == 'new'
  end
  
  def build_like_path
    path_parts = URI.split(request.fullpath)[5].split("/")
    
    return URI.join(path_parts[0..2].join("/")).to_s
  end
    
end
