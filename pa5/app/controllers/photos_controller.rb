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

    create_params = {}

    if params[:photo]
      create_params[:user_id] = params[:photo][:user_id]
      create_params[:date_time] = params[:photo][:date_time]

      if params[:photo][:file]
        file = params[:photo][:file]
        if file.respond_to?(:read)
          file_name = file.original_filename()
          file_path = "public/images/" + file_name
          file_contents = file.read()

          # TODO: this naming scheme has the weakness that if two files with same name are uploaded one will stomp another, alternatively use hashes of file contents
          create_params[:file_name] = file_name
        end
      end
    end

    @photo = Photo.create(create_params)
    if @photo.valid?
      #f = File.new(file_path,  "w+")
      #f.write(file_contents)
      #f.close()
      File.open(file_path, "wb") {|f| f.write(file_contents)}
      redirect_to(:controller => :photos, :action => :index, :id => session[:current_user_id])
    else
      render(:controller => :photos, :action => :new)
    end
  end

end
