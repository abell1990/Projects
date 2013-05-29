class CommentsController < ApplicationController

  before_filter :require_login, only: [:new, :create]
  before_filter :require_http_get, only: [:new]
  before_filter :require_http_post, only: [:create]


  # URL access: logged in users
  # HTTP method: GET
  def new

    # find photo to comment (if exists)
    if params[:id] and Photo.exists?(params[:id])
      @photo = Photo.find(params[:id])
      @comment = Comment.new()
    else
      add_alert(false, :alert_error, "That photo does not exist, or you did not provide a photo id.")
    end

  end

  # Action that handles HTTP POST requests to create comments
  # URL access: logged in users
  # HTTP method: POST
  def create

    @comment = Comment.new(params[:comment])

    if @comment.save() # does it pass validation?
      redirect_to(:controller => :photos, :action => :view, :id => @comment.photo.id)
    else
      @photo = Photo.find(params[:id])
      render(:action => :new, :id => @photo.id)
    end

  end

end
