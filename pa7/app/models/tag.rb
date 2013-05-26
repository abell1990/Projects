class Tag < ActiveRecord::Base
  attr_accessible :height, :photo_id, :user_id, :width, :x_coord, :y_coord

  belongs_to :user
  belongs_to :photo
end
