class ApplicationController < ActionController::Base
  helper_method :current_user
  # helper methods are available to the VIEWS
  
  def login!(user)
    # we come here from 'sessions#create' for one  
    # remember that when the user is initialized,
    # we set its session token
    @current_user = user
    # notice that this will then be set on login
    # so we don't have to query the database from the session hash???
    session[:session_token] = @current_user.session_token
  end

  def current_user
    if session[:session_token].nil?
      return nil
    else
      @current_user ||= User.find_by(session_token: session[:session_token])
    end
  end

  def logout!
    current_user.try(:reset_session_token)
    session[:session_token] = nil
  end
  
  def require_current_user!
    # redirects to login page if nobody is logged in
    redirect_to login_url if current_user.nil?
  end
  
  def require_this_user!
    # prevents user A from accessing a page for user B
    redirect_to root_path, notice: "naughty naughty" unless params[:id].to_i == current_user.id
  end
  
end
