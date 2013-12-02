class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.datetime :expire
      t.string :hbo_id
      t.string :image
      t.string :imdb_link
      t.string :imdb_rating
      t.string :rating
      t.text :summary
      t.string :title
      t.string :year

      t.timestamps
    end
  end
end
