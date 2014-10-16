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


require 'rails_helper'

describe Rating do

  before do
    user = User.create(name: "Christos", email: "test@gmail.com", password: "12345678", password_confirmation: "12345678")
    another_user = User.create(name: "George", email: "test2@gmail.com", password: "12345678", password_confirmation: "12345678")
    movie = Movie.create(title: "Sherlock Holmes", description: "A mystery film", user: another_user, published_at: Date.today)
    @rating = Rating.create(user: user, movie: movie, positive: true)
  end

  subject { @rating }

  it { should respond_to(:user_id) }
  it { should respond_to(:movie_id) }
  it { should respond_to(:positive?) }
  it { should respond_to(:negative?) }
  it { should be_valid }

end

