class Tag < ActiveRecord::Base
  attr_accessible :photo_id, :user_id, :x_coord, :y_coord, :height, :width

  belongs_to :photo
  belongs_to :user

  validates :photo_id, :user_id, :x_coord, :y_coord, :height, :width, :presence => true
  validates :x_coord, :y_coord, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :height, :width, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :photo, :user, :presence => true
end
