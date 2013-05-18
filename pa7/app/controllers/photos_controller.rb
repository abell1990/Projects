class PhotosController < ApplicationController

  before_filter :require_login, only: [:new, :create]
  before_filter :require_http_get, only: [:index, :new]
  before_filter :require_http_post, only: [:create]


  # URL access: anyone
  # HTTP method: GET
  def index

    # the view needs to know if whoever made request is logged in, to display options such as
    # adding new comments
    if logged_in?
      @logged_in = true
      @new_comment = Comment.new()
      @new_comment.user = User.find(current_user_id)
    end

    # Check if whoever made request is logged in, this will be useful for the view to know if it
    # should display the create comment option next to the photos. Logged in users should be
    # this option and non-logged in users should not.
    if params[:id] and User.exists?(params[:id])
  		@user = User.find(params[:id])
    else
      add_alert(false, :alert_error, "That user does not exist, or you did not provide a user id.")
    end

  end

  # URL access: logged in users
  # HTTP method: GET
  def new

    @photo = Photo.new()

  end

  # URL access: logged in users
  # HTTP method: POST
  def create

    @photo = Photo.new(params[:photo])

    if @photo.save() # does it pass validation? if so, copy image to /public/images directory
      file_path = "public/images/" + @photo.file_name
      file_contents = params[:photo][:file].read()
      File.open(file_path, "wb") {|f| f.write(file_contents)}

      redirect_to(:controller => :photos, :action => :index, :id => current_user_id)
    else
      render(:controller => :photos, :action => :new)
    end

  end

end
