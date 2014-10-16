# == Schema Information
#
# Table name: movies
#
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#  user_id                :integer
#  ratings_count          :integer
#  likes_count            :integer
#  hates_count            :integer
#  likes_to_ratings_ratio :integer
#  published_at           :datetime
#

class Movie < ActiveRecord::Base

  # Associations
  belongs_to :user
  has_many :ratings
  has_many :critics, through: :ratings, source: :user

  # Validations
  validates :title,
            presence: true,
            length: (1..150)

  validates :description,
            presence: true

  validates :published_at,
            presence: true,
            inclusion: { in: (Date.parse("january 1 1900")..Date.today) }

  validates :user_id,
            presence: true,
            numericality: { only_integer: true }

  validates_presence_of :user, message: "User doesn't exist!"

  # Custom validations
  validate :check_description_word_count

  # Scopes
  scope :custom_order, -> (column_name) do
    order("#{column_name} DESC") if column_name.in? allowed_order_columns
  end

  # Callbacks
  before_validation :strip_empty_space
  before_create :initialize_counters

  before_update :update_likes_to_ratings_ratio, if: :counters_changed?,
                unless: Proc.new { |movie| movie.unqualified_for_ratio? }

  # Methods

  # Whitelist columns the user can order
  def self.allowed_order_columns
    %w(likes_count hates_count ratings_count likes_to_ratings_ratio published_at created_at)
  end

  # Should have at list 5 ratings to get an objective ratio
  def unqualified_for_ratio?
    ratings_count < 5
  end

  private

    # Remove whitespace from input
    def strip_empty_space
      self.title = title.strip unless title.blank?
      self.description = description.strip unless description.blank?
    end

    def initialize_counters
      self.ratings_count = 0
      self.likes_count = 0
      self.hates_count = 0
      self.likes_to_ratings_ratio = 0
    end

    # Description should be 2 or more words
    def check_description_word_count
      unless description.blank?
        errors.add(:description, "Description should be at least 2 words long.") if description.split(" ").count < 2
      end
    end

    def counters_changed?
      likes_count_changed? || hates_count_changed?
    end

    def update_likes_to_ratings_ratio
      self.likes_to_ratings_ratio = ((likes_count.to_f / ratings_count).round(2) * 100).to_i
    end

end
