# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  movie_id   :integer
#  positive   :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Rating < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :movie, counter_cache: true

  # Validations
  validates :user_id,
            uniqueness: { scope: :movie_id },
            presence: true,
            numericality: { only_integer: true }

  validates :movie_id,
            presence: true,
            numericality: { only_integer: true }

  validates :positive,
            inclusion: { in: [true, false] }

  validates_presence_of :movie, message: "Movie doesn't exist!"
  validates_presence_of :user, message: "User doesn't exist!"

  # Custom validations
  validate :should_not_belong_to_user_posted_movie

  # Scopes
  scope :liked, -> do
    where(positive: true)
  end

  scope :hated, -> do
    where(positive: false)
  end

  # Callbacks
  after_save :update_counters_in_movie
  after_destroy :update_counters_in_movie

  # Methods

  def negative?
    positive == false
  end

  private

    # A user shouldn't be able to rate his own posted movie
    def should_not_belong_to_user_posted_movie
      errors.add(:user_id, "Poster of the movie cannot add a rating") if user == movie.user
    end

    # Update appropriate counters when a record is changed
    def update_counters_in_movie
      unless movie.blank?
        movie.update(likes_count: movie.ratings.liked.count, hates_count: movie.ratings.hated.count)
      end
    end

end
