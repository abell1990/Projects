class PhotosController < ApplicationController

  # URL access: anyone
  # HTTP method: GET
  def index
    # check if whoever made request is logged in
    if session[:current_user_id]
      @logged_in = true
    end

    # find user they are looking for (if exists)
    if params[:id] and User.exists?(params[:id])
  		@user = User.find(params[:id])
    else
      @flash = {:alert_error => "That user does not exist, or you did not provide a user id."}
    end
  end

  # URL access: logged in users
  # HTTP method: GET
  def new
    unless validate_login
      return
    end

    @photo = Photo.new()
  end

  # URL access: logged in users
  # HTTP method: POST
  def create
    unless validate_login
      return
    end

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

    @photo = Photo.new(params[:photo])
    if @photo.save() # does it pass validation?
      # copy image to /public/images directory
      file_path = "public/images/" + @photo.file_name
      file_contents = params[:photo][:file].read()
      File.open(file_path, "wb") {|f| f.write(file_contents)}

      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    else
      render(:controller => :photos, :action => :new)
    end
  end

end
