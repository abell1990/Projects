class ApplicationController < ActionController::Base

  protect_from_forgery

  $project_number = 5

  # TODO: move helpers to another file

  private

  def add_alert(redirecting, alertType, message)

    if redirecting
      if flash[alertType]
        flash[alertType] << message
      else
        flash[alertType] = [message]
      end
    else
      if flash.now[alertType]
        flash.now[alertType] << message
      else
        flash.now[alertType] = [message]
      end
    end

  end

  def require_login
    unless logged_in?
      add_alert(true, :alert_info, "You must be logged in to access this content.")
      redirect_to(:controller => :users, :action => :login)
    end
  end

  def logged_in?
    return session[:current_user_id] != nil
  end

  def require_http_get
    unless request.get?
      add_alert(true, :alert_error, "Invalid HTTP request. Please only do GET requests to this URL.")
      redirect_to(:controller => :site, :action => :error)
    end
  end

  def require_http_post
    unless request.post?
      add_alert(true, :alert_error, "Invalid HTTP request. Please only do POST requests to this URL.")
      redirect_to(:controller => :site, :action => :error)
    end
  end

end
