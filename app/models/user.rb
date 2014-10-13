class User < ActiveRecord::Base

  has_secure_password

  # Validations
  validates :name,
            presence: true,
            length: { maximum: 40 }


  EMAIL_REGEXPRESSION = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: EMAIL_REGEXPRESSION }

  validates :password,
            length: { minimum: 6 }

  # Callbacks
  before_save :downcase_email
  before_create :create_remember_token

  # Methods

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    def downcase_email
      self.email = email.downcase
    end

end
