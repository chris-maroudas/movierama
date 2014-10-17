# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_token  :string(255)
#

class User < ActiveRecord::Base

  has_secure_password

  # Associations
  has_many :movies
  has_many :ratings, dependent: :destroy
  has_many :rated_movies, through: :ratings, source: :movie

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

  def has_rated?(movie)
    movie.in? rated_movies
  end

  def has_created?(movie)
    self == movie.user
  end

  def get_rating_for(movie)
    ratings.where(user: self, movie: movie).first
  end

  def has_liked?(movie)
    rating = get_rating_for(movie)
    if !rating.nil? && rating.positive?
      return true
    end
    false
  end

  def has_hated?(movie)
    rating = get_rating_for(movie)
    if !rating.nil? && rating.negative?
      return true
    end
    false
  end

  # Returns liked or hated movies, depending on choice
  def get_movies_by(choice)
    scope = choice == "likes" ? "liked" : "hated"
    movies = []
    ratings.send(scope).each do |rating|
      movies << rating.movie
    end
    movies
  end

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
