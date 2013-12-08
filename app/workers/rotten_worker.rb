class RottenWorker
  include Sidekiq::Worker

  def perform(id)
    @movie = Movie.find(id)
    @rotten_movie = RottenMovie.find(:title => @movie.title, :limit => 1)
    unless @rotten_movie.count == 0
      @movie.rotten_critics_score = @rotten_movie.first.ratings.critics_score
      @movie.rotten_audience_score = @rotten_movie.first.ratings.audience_score
      if @movie.save
        logger.info("RottenWorker - Updated #{@movie.title}")
      end
    end
  end
end