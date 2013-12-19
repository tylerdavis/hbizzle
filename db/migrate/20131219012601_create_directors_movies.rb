class CreateDirectorsMovies < ActiveRecord::Migration
  def change
    create_table :directors_movies do |t|
      t.references :director, index: true
      t.references :movie, index: true
    end
  end
end
