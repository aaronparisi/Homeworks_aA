class ApplicationController < ActionController::Base
  before_action :set_user

  def set_user
    if session[:user_id]
      @curUser = User.find(session[:user_id])
    else
      @curUser = nil
    end
  end
end
