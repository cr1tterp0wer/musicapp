# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  attr_reader :password
  after_initialize :ensure_session

  validates :email,:session_token, presence: true, uniqueness:true
  validates :password, allow_nil:true, length: {minimum: 6}

  #PASSWORD SPECIFIC
  def password=(pass)
    @password = pass
    self.password_digest = BCrypt::Password.create(pass)
  end
  
  def is_password?(pass)
    BCrypt::Password.new(self.password_digest).is_password?(pass)
  end

  #SESSION SPECIFIC
  def ensure_session
    self.session_token ||= User.generate_session_token
  end
   
  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end
  
  ##
  #
  # CLASS METHODS / FUNCTIONS
  #
  ## 
  def self.find_by_credentials(email, pass)
    current = User.find_by(email: email)
    return nil if current.nil?
    return nil unless current.is_password?(pass)
    current
  end
  def self.find_by_session(session)
    current = User.find_by(session_token: session)
    return nil if current.nil?
    current
  end
  private
  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end
end
