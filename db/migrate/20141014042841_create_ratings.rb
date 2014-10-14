class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user, index: true
      t.references :movie, index: true
      t.references :user, index: true
      t.boolean :positive

      t.timestamps
    end
    add_index :ratings, [:user_id, :movie_id]
  end
end
