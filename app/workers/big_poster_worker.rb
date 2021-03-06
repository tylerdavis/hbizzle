class BigPosterWorker
  include Sidekiq::Worker

  def perform(id)
    @movie = Movie.find(id)

    imdb_movie = Imdb::Movie.search(@movie.title).first
    if imdb_movie and imdb_movie.poster
      @movie.big_poster = Dragonfly.app.fetch_url(imdb_movie.poster).thumb('x260')
      @movie.save
    end
  end
end