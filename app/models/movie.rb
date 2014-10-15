# == Schema Information
#
# Table name: movies
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  ratings_count :integer
#  likes_count   :integer
#  hates_count   :integer
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
  # Methods

  # Whitelist columns the user can order
  def self.allowed_order_columns
    %w(likes_count hates_count created_at)
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
    end

    # Description should be 2 or more words
    def check_description_word_count
      unless description.blank?
        errors.add(:description, "Description should be at least 2 words long.") if description.split(" ").count < 2
      end
    end

end
