class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :login

  has_many :photos
  has_many :comments

  def full_name
  	self.first_name + " " + self.last_name
  end
end
