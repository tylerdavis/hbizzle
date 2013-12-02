class AddRottenScoresToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :rotten_critics_score, :string
    add_column :movies, :rotten_audience_score, :string
  end
end
