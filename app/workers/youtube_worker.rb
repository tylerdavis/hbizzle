class YoutubeWorker
  include Sidekiq::Worker

  sidekiq_options throttle: { threshold: 140, period: 1.minute }

  def perform(movie_id)
    @movie = Movie.find(movie_id)
    movies = Enceladus::Movie.find_by_title(@movie.title)
    if movies.total_results > 0
      movie = movies.first
      if movie.youtube_trailers.any?
        @movie.update_attribute(:youtube_id, movie.youtube_trailers.first.source)
      end
    end
  end

end