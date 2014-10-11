# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Movie < ActiveRecord::Base

  # Validations
  validates :title,
            presence: true,
            length: (2..255)

  validates :description,
            presence: true

  validate :check_description_word_count

  # Callbacks
  before_validation :strip_empty_space

  # Methods
  private

    # Remove whitespace from input
    def strip_empty_space
      self.title = title.strip unless title.blank?
      self.description = description.strip unless description.blank?
    end

    # Description should be 2 or more words
    def check_description_word_count
      unless description.blank?
        errors.add(:description, "Description should be at least 2 words long.") if description.split(" ").count < 2
      end
    end

end
