class UsersController < ApplicationController

  # URL access: anyone
  # HTTP method: GET
  def index

    # validate we got a HTTP GET request
    unless validate_http_get
      return
    end

    @all_users = User.all

    if @all_users.empty?
      add_alert(false, :alert_info, "There are no registered users.")
    end

  end

  # URL access: anyone
  # HTTP method: GET
  def login

    # validate we got a HTTP GET request
    unless validate_http_get
      return
    end

    # if whoever made request is logged in already redirect to their photos page
    if session[:current_user_id]
      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    end

  end

  # URL access: anyone
  # HTTP method: GET
  # TODO: this should be a post
  def logout

    # validate we got a HTTP GET request
    unless validate_http_get
      return
    end

    if session[:current_user_id]
      add_alert(true, :alert_success, "You have successfully logged out.")
    end

    session[:current_user_id] = nil
    redirect_to(:controller => :users, :action => :login)

  end

  # Action that handles HTTP POST requests to login users
  # URL access: anyone
  # HTTP method: POST
  def post_login

    # validate we got a HTTP POST request
    unless validate_http_post
      return
    end

    # if whoever made request is logged in already redirect to their photos page
    if session[:current_user_id]
      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    end

    user = User.find_by_login(params[:login])

    if user and user.password_valid?(params[:password])  # valid login, proceed to their photos page
      session[:current_user_id] = user.id
      add_alert(true, :alert_info, "Welcome back #{user.first_name}!")
      redirect_to(:controller => :photos, :action => :index, :id => user.id)
    else     # invalid login, go back to login page with error msg
      add_alert(false, :alert_error, "Invalid username and/or password.")
      render(:controller => :users, :action => :login)
    end

  end

  # URL access: anyone
  # HTTP method: GET
  def new

    # validate we got a HTTP GET request
    unless validate_http_get
      return
    end

    # if whoever made request is logged in already redirect to their photos page
    if session[:current_user_id]
      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    end

    @user = User.new()

  end

  # Action that handles HTTP POST requests to create/register users
  # URL access: anyone
  # HTTP method: POST
  def create

    # validate we got a HTTP POST request
    unless validate_http_post
      return
    end

    # if whoever made request is logged in already redirect to their photos page
    if session[:current_user_id]
      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    end

    @user = User.new(params[:user])

    if @user.save() # does it pass validation?
      add_alert(true, :alert_success, "Registration successful.")
      redirect_to(:controller => :users, :action => :login)
    else
      render(:controller => :users, :action => :new)
    end

  end

end
