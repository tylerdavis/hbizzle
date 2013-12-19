class ImdbWorker
  include Sidekiq::Worker

  def perform(id)
    @movie = Movie.find(id)
    imdb_movies = Imdb::Movie.search(@movie.title)
    imdb_movie = imdb_movies.select { |m| m.title.include? @movie.year }.first
    unless imdb_movie
      @movie.imdb_link = imdb_movie.url
      @movie.imdb_rating = imdb_movie.rating.to_s
      if @movie.save
        logger.info("ImdbWorker - Updated #{@movie.title}")
      end
    end
  end

end
