class TheMovieDbWorker
  include Sidekiq::Worker

  def perform(movie_id)
    @movie = Movie.find(movie_id)
    movies = Tmdb::Movie.find('Ace Ventura')
    if movies.any?
      id = movies.first.id
      trailers = Tmdb::Movie.trailers(id)
      if trailers.youtube.any?
        @movie.update_attribute(:youtube_id, trailers.youtube.first.source)
      end
    end
  end

end