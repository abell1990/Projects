class CommentsController < ApplicationController
  def new
    @photo = Photo.find(params[:id])
    @comment = Comment.new()
  end

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
