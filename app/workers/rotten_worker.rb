class RottenWorker
  include Sidekiq::Worker

  def perform(id)
    @movie = Movie.find(id)
    @rotten_movie = RottenMovie.find(:title => @movie.title, :limit => 1)
    @movie.rotten_critics_score = @rotten_movie.first.ratings.critics_score
    @movie.rotten_audience_score = @rotten_movie.first.ratings.audience_score
    @movie.save
  end
end