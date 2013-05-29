class TagsController < ApplicationController
  before_filter :require_login, only: [:new, :create]
  before_filter :require_http_get, only: [:new]
  before_filter :require_http_post, only: [:create]


  # URL access: logged in users
  # HTTP method: GET
  def new
    # find photo to comment (if exists)
    if params[:id] and Photo.exists?(params[:id])
      @photo = Photo.find(params[:id])
      @select_options = []
      User.all.each{ |u| @select_options << [u.full_name, u.id]}
      @select_options.sort!
      @tag = Tag.new()
    else
      add_alert(false, :alert_error, "That photo does not exist, or you did not provide a photo id.")
    end
  end

  # Action that handles HTTP POST requests to create tags
  # URL access: logged in users
  # HTTP method: POST
  def create

    @tag = Tag.new(params[:tag])

    if @tag.save() # does it pass validation?
      redirect_to(:controller => :photos, :action => :view, :id => @tag.photo.id)
    else
      @photo = Photo.find(params[:id])
      @select_options = []
      User.all.each{ |u| @select_options << [u.full_name, u.id]}
      @select_options.sort!
      render(:controller => :tags, :action => :new, :id => @photo.id)  # TODO: fully qualify :controller elsewhere
    end

  end

end
