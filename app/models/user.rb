class User
  include DataMapper::Resource
  include BCrypt

  attr_accessor :password_confirmation

  property :id,              Serial
  property :email,           String, required: true, unique: true, format: :email_address
  property :username,        String, required: true, unique: true
  property :name,            String, required: true
  property :password_digest, Text

  has n, :peeps

  validates_confirmation_of :password
  validates_presence_of :password

  def password=(password)
    self.password_digest = Password.create(password) if password.size > 0
  end

  def password
    @password ||= Password.new(password_digest) if password_digest
  end

  def self.authenticate(email, pass)
    user = first(email: email)
    !user.nil? && user.password == pass ? user : nil
  end
end
