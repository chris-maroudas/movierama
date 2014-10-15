class AddLikesToRatingsRatioToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :likes_to_ratings_ratio, :integer
  end
end
