class AddImagesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :poster_uid, :string
  end
end
