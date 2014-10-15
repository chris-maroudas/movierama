class AddLikeAndHatedCountToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :likes_count, :integer
    add_column :movies, :hates_count, :integer
  end
end
