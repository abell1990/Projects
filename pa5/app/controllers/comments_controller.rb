class CommentsController < ApplicationController

  # URL access: logged in users
  # HTTP method: GET
  def new

    # validate we got a HTTP GET request
    unless validate_http_get
      return
    end

    # require user to be logged in to create a comment
    unless validate_login
      return
    end

    # find photo to comment (if exists)
    if params[:id] and Photo.exists?(params[:id])
      @photo = Photo.find(params[:id])
      @comment = Comment.new()
    else
      @flash = {:alert_error => "That photo does not exist, or you did not provide a photo id."}
    end

  end

  # Action that handles HTTP POST requests to create comments
  # URL access: logged in users
  # HTTP method: POST
  def create

    # validate we got a HTTP POST request
    unless validate_http_post
      return
    end

    unless validate_login
      return
    end

    @comment = Comment.new(params[:comment])

    if @comment.save() # does it pass validation?
      redirect_to(:controller => :photos, :action => :index, :id => @comment.photo.user.id)
    else
      @photo = Photo.find(params[:id])
      render(:action => :new, :id => @photo.id)
    end

  end

end
