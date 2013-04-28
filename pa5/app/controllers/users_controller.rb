class UsersController < ApplicationController
  
  def index
  	@all_users = User.find(:all)
  end

end
