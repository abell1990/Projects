class ApplicationController < ActionController::Base

  protect_from_forgery

  $project_number = 5

  # TODO: move helpers to another file

  def validate_http_get
    if request.post?
      add_alert(true, :alert_error, "Invalid HTTP request. Please only do GET requests to this URL.")
      redirect_to(:controller => :site, :action => :error)
      return false
    end

    return true
  end

  def validate_http_post
    if request.get?
      add_alert(true, :alert_error, "Invalid HTTP request. Please only do POST requests to this URL.")
      redirect_to(:controller => :site, :action => :error)
      return false
    end

    return true
  end

  def add_alert(redirecting, alertType, message)

    if redirecting
      if flash[alertType]
        flash[alertType] << message
      else
        flash[alertType] = [message]
      end
    else
      if !@flash
        @flash = {}
      end

      if @flash[alertType]
        @flash[alertType] << message
      else
        @flash[alertType] = [message]
      end
    end

  end

  private

  def require_login
    unless logged_in?
      add_alert(true, :alert_info, "You must be logged in to access this content.")
      redirect_to(:controller => :users, :action => :login)
    end
  end

  def logged_in?
    return session[:current_user_id] != nil
  end

end
