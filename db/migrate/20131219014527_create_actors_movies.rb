class CreateActorsMovies < ActiveRecord::Migration
  def change
    create_table :actors_movies do |t|
      t.references :actor, index: true
      t.references :movie, index: true
    end
  end
end
