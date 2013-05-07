class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :login, :password, :password_confirmation
  attr_accessor :password_tmp_copy

  has_many :photos
  has_many :comments

  @@SALT_RANGE = 1000000000


  def full_name
  	self.first_name + " " + self.last_name
  end

  def password
    return self.password_tmp_copy
  end

  # TODO: I want to restrict access to password_digest and salt fields, they should only be settable by calling password=
  def password=(password)
    self.salt = Random.rand(@@SALT_RANGE).to_s
    self.password_digest = Digest::SHA1.hexdigest(password + self.salt)

    # TODO: should return something??
    # this is not a field in database so it does not get saved persistently
    # we only saved it around to check it against the password_confirmation field
    # provided in the registration form for validation
    self.password_tmp_copy = password
  end

  def password_valid?(candidate_password)
    unless candidate_password # check for nil
      return false
    end

    candidate_digest = Digest::SHA1.hexdigest(candidate_password + self.salt)
    return candidate_digest == self.password_digest
  end

  # validates password and password_confirmation entered at registration match
  validates :password, :confirmation => true
  # validates login element is unique
  validates :login, :uniqueness => {:case_sensitive => false, :message => "That username is already registered."}
  # validate presence of all fields
  validates :first_name, :last_name, :login, :password, :password_confirmation, :presence => true
end
