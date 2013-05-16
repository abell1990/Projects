class PhotosController < ApplicationController

  before_filter :require_login, only: [:new, :create]


  # URL access: anyone
  # HTTP method: GET
  def index

    # validate we got a HTTP GET request
    unless validate_http_get
      return
    end

    # check if whoever made request is logged in
    if session[:current_user_id]
      @logged_in = true
    end

    # find user they are looking for (if exists)
    if params[:id] and User.exists?(params[:id])
  		@user = User.find(params[:id])
    else
      add_alert(false, :alert_error, "That user does not exist, or you did not provide a user id.")
    end

  end

  # URL access: logged in users
  # HTTP method: GET
  def new

    # validate we got a HTTP GET request
    unless validate_http_get
      return
    end

    @photo = Photo.new()

  end

  # URL access: logged in users
  # HTTP method: POST
  def create

    # validate we got a HTTP POST request
    unless validate_http_post
      return
    end

    @photo = Photo.new(params[:photo])

    if @photo.save() # does it pass validation?
      # copy image to /public/images directory
      # TODO: do not write if it already exists
      file_path = "public/images/" + @photo.file_name
      file_contents = params[:photo][:file].read()
      File.open(file_path, "wb") {|f| f.write(file_contents)}

      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    else
      render(:controller => :photos, :action => :new)
    end

  end

end
