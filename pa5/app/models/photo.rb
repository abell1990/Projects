class Photo < ActiveRecord::Base
  attr_accessible :user_id, :date_time, :file_name, :file
  attr_accessor :file_tmp_copy

  belongs_to :user
  has_many :comments

  @@accepted_file_formats = [".png", ".gif", ".jpg", ".jpeg", ".bmp", ".tiff"]


  def file
     return self.file_tmp_copy
  end

  def file=(file)
    if file and file.respond_to?(:original_filename) and file.respond_to?(:read)
      format = File.extname(file.original_filename()).downcase

      # name file after its content hash
      self.file_name = Digest::SHA1.hexdigest( file.read() ) + format
      file.rewind()

      # TODO: try not saving this
      self.file_tmp_copy = file
    end
  end

  def validate_file_extension
    # validate image file extension
    if file_name
      format = File.extname(file_name)

      # TODO: validate based on ruby attr instead of extname
      if !@@accepted_file_formats.include?(format)
        errors.add(:file, "Incorrect file extension.")
      end
    end
  end


  validates :user_id, :date_time, :file, :presence => true
  validate :validate_file_extension
end
