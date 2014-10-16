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

require 'rails_helper'

describe Movie do

  before do
    user = User.create(name: "Christos", email: "test@gmail.com", password: "12345678", password_confirmation: "12345678")
    @movie = Movie.new(title: "Sherlock Holmes", description: "A mystery film", user: user, published_at: Date.today)
  end

  subject { @movie }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:ratings_count) }
  it { should respond_to(:likes_count) }
  it { should respond_to(:hates_count) }
  it { should respond_to(:published_at) }
  it { should respond_to(:likes_to_ratings_ratio) }
  it { should be_valid }



  describe "when a movie is saved" do
    before { @movie.save }
    it { should be_unqualified_for_ratio }
  end

end
