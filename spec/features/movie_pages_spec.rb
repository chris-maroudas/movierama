require 'rails_helper'

describe "Movies pages" do

  subject { page }

  describe "Movies index page" do
    before { visit movies_path }
    it { should have_content('Sort by') }
  end

end
