class ApplicationController < ActionController::Base

  protect_from_forgery

  $project_number = 5

  def validate_login
    if !session[:current_user_id]
      flash[:alert_info] = "You must be logged in to access this content."
      redirect_to(:controller => :users, :action => :login)
      return false
    end

    return true
  end

  def validate_http_get(controller, action)
    if request.post?
      redirect_to(:controller => controller, :action => action)
      return false
    end

    return true
  end

  def validate_http_post(controller, action)
    if request.get?
      redirect_to(:controller => controller, :action => action)
      return false
    end

    return true
  end

end
