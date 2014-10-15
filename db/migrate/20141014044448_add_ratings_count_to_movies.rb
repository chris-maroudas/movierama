class AddRatingsCountToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :ratings_count, :integer
  end
end
