class AddPublishedAtToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :published_at, :date
  end
end
