class PhotosController < ApplicationController

  def index
  	if params[:id] and User.exists?(params[:id])
  		@user = User.find(params[:id])
  	end
  end

end
