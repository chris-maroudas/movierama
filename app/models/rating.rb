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
  belongs_to :movie

  # Validations
  validates :user_id,
            uniqueness: { scope: :movie_id },
            presence: true,
            numericality: { only_integer: true }

  validates :movie_id,
            presence: true,
            numericality: { only_integer: true }

  validates_presence_of :movie, message: "Movie doesn't exist!"
  validates_presence_of :user, message: "User doesn't exist!"

  # Scopes
  scope :liked, -> do
    where(positive: true)
  end

  scope :hated, -> do
    where(positive: false)
  end

  # Methods

end
