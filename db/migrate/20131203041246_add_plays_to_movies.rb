class AddPlaysToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :plays, :integer, default: 0
  end
end
