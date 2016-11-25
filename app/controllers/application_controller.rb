class ApplicationController < ActionController::Base
  helper ApplicationHelper
  protect_from_forgery

  before_filter :require_auth, :only => [:new, :edit, :create]

  def require_auth
    logger.debug "checking permissions"
    return false if check_current_user.blank?
    true
  end
  
  def my_authenticate
     authenticate_with_http_basic { |u, p| 
        user = User.find_by_login_id(u)
        if user
          user.authenticate(p) 
        else
          false
        end
       }
  end


  def check_current_user
    logger.info session[:user_id]
    if session[:user_id].blank?
      if user = my_authenticate
        session[:user_id] = user.id
        session[:expires_in]=30.minutes.from_now
      else
        request_http_basic_authentication
        return
      end
    else
      unless user = User.find(session[:user_id])
        session[:user_id] = nil
        return
      else
        reset_session
      end
    end
    session[:user_id]
  end


end
