class Photo < ActiveRecord::Base
  attr_accessible :user_id, :date_time, :file_name, :file
  attr_accessor :file_tmp_copy

  after_save :save_photo_file
  skip_callback :save, :after, :save_photo_file, :if => lambda { self.file_tmp_copy == nil }

  belongs_to :user
  has_many :comments
  has_many :tags

  @@accepted_file_formats = [".png", ".gif", ".jpg", ".jpeg", ".bmp", ".tiff"]


  def file
     return self.file_tmp_copy
  end

  def file=(file)
    if file and file.respond_to?(:original_filename) and file.respond_to?(:read)
      format = File.extname(file.original_filename()).downcase

      # name file after its content hash and timestamp
      self.file_name = Digest::SHA1.hexdigest( file.read() ) + "-" + DateTime.now.strftime("%s") + format
      file.rewind()

      self.file_tmp_copy = file
    end
  end

  def validate_file_extension
    # validate image file extension
    if file_name
      format = File.extname(file_name)

      if !@@accepted_file_formats.include?(format)
        errors.add(:file, "Incorrect file extension.")
      end
    end
  end

  def save_photo_file
    # if object passed validation, copy image to /public/images directory
    file_path = "public/images/" + self.file_name
    file_contents = self.file_tmp_copy.read()
    File.open(file_path, "wb") {|f| f.write(file_contents)}
  end


  validates :user_id, :date_time, :file, :presence => true
  validate :validate_file_extension
end
