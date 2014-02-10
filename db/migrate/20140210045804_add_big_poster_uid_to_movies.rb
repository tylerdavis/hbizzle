class AddBigPosterUidToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :big_poster_uid, :string
  end
end
