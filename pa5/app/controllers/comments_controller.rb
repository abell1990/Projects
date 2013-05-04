class CommentsController < ApplicationController

  # URL access: logged in users
  # HTTP method: GET
  def new
    if !validate_login
      return
    end

    # find photo to comment (if exists)
    if params[:id] and Photo.exists?(params[:id])
      @photo = Photo.find(params[:id])
      @comment = Comment.new()
    end
  end

  # Action that handles HTTP POST requests to create comments
  # URL access: logged in users
  # HTTP method: POST
  def create
    @comment = Comment.create(params[:comment])
    if @comment.valid?
      redirect_to(:controller => :photos, :action => :index, :id => @comment.photo.user.id)
    else
      @photo = Photo.find(params[:id])
      render(:action => :new, :id => @photo.id)
    end
  end
end
