class UsersController < ApplicationController
  
  def index
    if !session[:current_user_id]
      flash[:login_info] = "Please login to see this content."
      redirect_to(:controller => :users, :action => :login)
    end

  	@all_users = User.all
  end

  def login
    if session[:current_user_id]
      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    end
  end

  def logout
    if session[:current_user_id]
      flash[:login_success] = "You have successfully logged out."
    end

    session[:current_user_id] = nil
    redirect_to(:controller => :users, :action => :login)
  end

  def post_login
    user = User.find_by_login(params[:login])

    if user
      session[:current_user_id] = user.id
      redirect_to(:controller => :photos, :action => :index, :id => user.id)
    else
      flash[:login_error] = "Invalid username."
      render(:controller => :users, :action => :login)
    end

  end

end
