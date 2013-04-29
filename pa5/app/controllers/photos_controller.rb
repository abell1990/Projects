class PhotosController < ApplicationController

  def index
    if !session[:current_user_id]
      flash[:login_info] = "Please login to see this content."
      redirect_to(:controller => :users, :action => :login)
    end

    if params[:id] and User.exists?(params[:id])
  		@user = User.find(params[:id])
  	end
  end

end
