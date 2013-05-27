class TagController < ApplicationController
  before_filter :require_login, only: [:new, :create]
  before_filter :require_http_get, only: [:new]
  before_filter :require_http_post, only: [:create]


  # URL access: logged in users
  # HTTP method: GET
  def new
    # TODO: fill in
  end

  # Action that handles HTTP POST requests to create tags
  # URL access: logged in users
  # HTTP method: POST
  def create

    @tag = Tag.new(params[:comment])

    if @tag.save() # does it pass validation?
      redirect_to(:controller => :photos, :action => :index, :id => @comment.photo.user.id)
    else
      # TODO: fill in
    end

  end

end
