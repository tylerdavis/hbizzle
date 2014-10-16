class CreatePlatformMovies < ActiveRecord::Migration

  def up
    create_table :platform_movies do |t|
      t.string :type, null: false
      t.string :platform_id, null: false
      t.datetime :expires
      t.datetime :started
      t.references :movie, index: true
      t.integer :plays, default: 0, null: false
      t.boolean :disabled, default: true, null: false
      t.timestamps
    end

    Movie.all.each do |movie|
      HboMovie.create(plays: movie.plays, movie_id: movie.id, platform_id: movie.hbo_id, expires: movie.expire, started:movie.created_at)
    end

    remove_column :movies, :hbo_id
    remove_column :movies, :expire
    remove_column :movies, :imdb_link

    add_column :movies, :imdb_id, :string
    add_column :movies, :rotten_tomatoes_id, :string
  end

  def down
    add_column :movies, :hbo_id, :string
    add_column :movies, :expire, :datetime
    add_column :movies, :imdb_link, :string

    PlatformMovie.all.each do |pm|
      movie = pm.movie
      if pm.type = 'HboMovie'
        movie.hbo_id = pm.platform_id
      end
      movie.expire = pm.expires
    end

    remove_column :movies, :imdb_id
    remove_column :movies, :rotten_tomatoes_id

    drop_table :platform_movies
  end

end
