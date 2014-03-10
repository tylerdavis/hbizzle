class BigPosterWorker
  include Sidekiq::Worker

  def perform(id)
    @movie = Movie.find(id)

    imdb_movie = Imdb::Movie.search(@movie.title).first
    if imdb_movie
      @movie.big_poster = Dragonfly.app.fetch_url(imdb_movie.poster).thumb('300x')
      @movie.save
    end
  end
end