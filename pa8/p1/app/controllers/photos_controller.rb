class PhotosController < ApplicationController

  before_filter :require_login, only: [:new, :create]
  before_filter :require_http_get, only: [:index, :new, :view, :search]
  before_filter :require_http_post, only: [:create]


  # URL access: anyone
  # HTTP method: GET
  def index

    # Check if whoever made request is logged in, this will be useful for the view to know if it
    # should display the add photo option. Logged in users should see
    # this option and non-logged in users should not.
    if logged_in?
      @logged_in = true
    end

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

    if @photo.save()
      add_alert(true, :alert_success, "Photo added")
      redirect_to(:controller => :photos, :action => :index, :id => current_user_id)
    else
      render(:controller => :photos, :action => :new)
    end

  end

  # URL access: anyone
  # HTTP method: GET
  def view

    # Check if whoever made request is logged in, this will be useful for the view to know if it
    # should display options such as adding new comments, and tagging. Logged in users should see
    # these options and non-logged in users should not.
    if logged_in?
      @logged_in = true
      @new_comment = Comment.new()
      @new_comment.user = User.find(current_user_id)
    end

    if params[:id] and Photo.exists?(params[:id])
      @photo = Photo.find(params[:id])
      @tagged_users = []
      @photo.tags.each { |t| @tagged_users << t.user.full_name }
      @tagged_users = @tagged_users.uniq.sort
    else
      add_alert(false, :alert_error, "That photo does not exist, or you did not provide a photo id.")
    end
  end

  # URL access: anyone
  # HTTP method: GET
  def search

    @matches = []

    unless params[:search_str]
      render :text => @matches.to_json
      return
    end

    pattern = Regexp.new(Regexp.quote(params[:search_str].downcase))

    Photo.all.each do |p|

      comment_matches = false

      p.comments.each do |c|
        if c.comment.downcase =~ pattern
          comment_matches = true
          @matches << "/images/#{p.file_name}"
          break
        end
      end

      if !comment_matches
        p.tags.each do |t|
          if t.user.full_name.downcase =~ pattern
            @matches << "/images/#{p.file_name}"
            break
          end
        end
      end

    end

    render :text => @matches.to_json

  end

end
