class UsersController < ApplicationController

  # URL access: anyone
  # HTTP method: GET
  def index
  	@all_users = User.all

    if @all_users.empty?
      flash[:alert_info] = "There are no registered users."
    end
  end

  # URL access: anyone
  # HTTP method: GET
  def login
    # if whoever made request is logged in already redirect to their photos page
    if session[:current_user_id]
      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    end
  end

  # URL access: anyone
  # HTTP method: GET
  def logout
    if session[:current_user_id]
      flash[:alert_success] = "You have successfully logged out."
    end

    session[:current_user_id] = nil
    redirect_to(:controller => :users, :action => :login)
  end

  # Action that handles HTTP POST requests to login users
  # URL access: anyone
  # HTTP method: POST
  def post_login

    # don't allow HTTP GET requests to this URL, redirect to login page
    unless request.post?
      redirect_to(:controller => :users, :action => :login)
      return
    end

    user = User.find_by_login(params[:login])

    if user  # valid login, proceed to their photos page
      session[:current_user_id] = user.id
      redirect_to(:controller => :photos, :action => :index, :id => user.id)
    else     # invalid login, go back to login page with error msg
      flash[:alert_error] = "Invalid username."
      render(:controller => :users, :action => :login)
    end

  end

end
