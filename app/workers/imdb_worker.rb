class ImdbWorker
  include Sidekiq::Worker

  def perform(id)
    @movie = Movie.find(id)
    imdb_movies = Imdb::Movie.search(@movie.title)
    # imdb_movie = imdb_movies.select { |m| m.title.include? @movie.year }.first
    imdb_movie = imdb_movies.first
    if imdb_movie
      @movie.imdb_rating = imdb_movie.rating.to_s || nil
      if @movie.save
        logger.info("ImdbWorker - Updated #{@movie.title}")
      end
    end
  end

end
