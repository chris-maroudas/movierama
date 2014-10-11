require 'rails_helper'

describe Movie do

  before { @movie = Movie.new(title: "Sherlock Holmes", description: "Really great movie!") }

  subject { @movie }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should be_valid }
end