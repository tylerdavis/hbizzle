class YoutubeWorker
  include Sidekiq::Worker

  sidekiq_options throttle: { threshold: 140, period: 1.minute }

  def perform(movie_id)
    @movie = Movie.find(movie_id)
    movies = Tmdb::Movie.find(@movie.title)
    if movies.any?
      id = movies.first.id
      trailers = Tmdb::Movie.trailers(id)
      if trailers.youtube.any?
        @movie.update_attribute(:youtube_id, trailers.youtube.first.source)
      end
    end
  end

end