class ImdbWorker
  include Sidekiq::Worker

  def perform(id)
    @movie = Movie.find(id)
    imdb_movies = Imdb::Movie.search(@movie.title)
    imdb_movie = imdb_movies.select { |m| m.title.include? @movie.year }.first
    @movie.imdb_link = imdb_movie.url
    @movie.imdb_rating = imdb_movie.rating.to_s
    @movie.save
  end

end
