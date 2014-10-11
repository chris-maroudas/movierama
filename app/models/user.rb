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


  # Methods
  private

    def downcase_email
      self.email = email.downcase
    end

end
