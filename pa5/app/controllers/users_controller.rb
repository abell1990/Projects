class UsersController < ApplicationController

  # URL access: anyone
  # HTTP method: GET
  def index
  	@all_users = User.all

    if @all_users.empty?
      @flash = {:alert_info => "There are no registered users."}
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
      @flash = {:alert_error => "Invalid username."}
      render(:controller => :users, :action => :login)
    end

  end

  # URL access: anyone
  # HTTP method: GET
  def new
    @user = User.new()
  end

  # Action that handles HTTP POST requests to create/register users
  # URL access: anyone
  # HTTP method: POST
  def create
    # TODO: fix
    ## don't allow HTTP GET requests to this URL
    #unless request.post?
    #if !validate_http_post(:users)
    #if request.get?
    #  if params[:id]
    #    redirect_to(:action => :new, :id => @photo.id)
    #  else
    #
    #  end
    #
    #  return
    #end

    #unless validate_passwords_match(params[:user])
    #  @user = User.new()
    #  @flash = {:alert_error => "Passwords did not match."}
    #  render(:controller => :users, :action => :new)
    #  return
    #end

    #params[:user].delete(:re_password)

    #create_params = {}
    #
    #if params[:user]
    #  create_params[:first_name] = params[:user][:first_name]
    #  create_params[:last_name] = params[:user][:last_name]
    #  create_params[:login] = params[:user][:login]
    #  if params[:user][:password] == params[:user][:re_password]
    #    create_params[:password] = params[:user][:password]
    #  else
    #    @password_mismatch = true
    #  end
    #end


    @user = User.create(params[:user])
    if @user.valid?
      flash[:alert_success] = "Registration successful."
      redirect_to(:controller => :users, :action => :login)
    else
      render(:controller => :users, :action => :new)
    end
  end

end
