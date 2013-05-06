class Photo < ActiveRecord::Base
  attr_accessible :user_id, :date_time, :file_name
  
  belongs_to :user
  has_many :comments

  validates :user_id, :date_time, :file_name, :presence => true
  # TODO: add validation for file extension, and duplicate avoidance
end
