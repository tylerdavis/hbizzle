class PosterWorker
  include Sidekiq::Worker

  def perform(id)
    @movie = Movie.find(id)
    @movie.poster = Dragonfly.app.fetch_url(@movie.image).thumb('180x')
    if @movie.save
      logger.info("PosterWorker - Updated #{@movie.title}")
    end
  end

end
