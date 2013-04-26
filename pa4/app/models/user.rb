class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :photos
  has_many :comments
end
