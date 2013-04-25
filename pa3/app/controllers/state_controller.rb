class StateController < ApplicationController
  
  def filter
    if params[:substring]
      @substring = params[:substring]
      @results = State.filter(@substring)
    end
  end

end