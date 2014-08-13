class RottenWorker
  include Sidekiq::Worker

  sidekiq_options throttle: { threshold: 240, period: 1.minute }

  def perform(id)
    @movie = Movie.find(id)
    @rotten_movie = RottenMovie.find(:title => @movie.title, :limit => 1)
    unless @rotten_movie.empty?
      @movie.rotten_critics_score = @rotten_movie.ratings.critics_score
      @movie.rotten_audience_score = @rotten_movie.ratings.audience_score
      if @movie.save
        logger.info("RottenWorker - Updated #{@movie.title}")
      end
    end
  end
end