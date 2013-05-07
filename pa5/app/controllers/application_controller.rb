class ApplicationController < ActionController::Base

  protect_from_forgery

  $project_number = 5

  # TODO: move helpers to another file
  def validate_login
    if !session[:current_user_id]
      flash[:alert_info] = "You must be logged in to access this content."
      redirect_to(:controller => :users, :action => :login)
      return false
    end

    return true
  end

  def validate_http_get
    if request.post?
      flash[:alert_error] = "Invalid HTTP request. Please only do GET requests to this URL."
      redirect_to(:controller => :site, :action => :error)
      return false
    end

    return true
  end

  def validate_http_post
    if request.get?
      flash[:alert_error] = "Invalid HTTP request. Please only do POST requests to this URL."
      redirect_to(:controller => :site, :action => :error)
      return false
    end

    return true
  end

end
