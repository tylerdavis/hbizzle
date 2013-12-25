class AddIndexToMovies < ActiveRecord::Migration
  def change
    add_index :movies, :hbo_id, unique: true, order: { hbo_id: :asc }
  end
end
