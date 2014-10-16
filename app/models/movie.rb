class Movie < ActiveRecord::Base

  has_many :platform_movies
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :directors

  validates :title, uniqueness: true

  dragonfly_accessor :big_poster
  dragonfly_accessor :poster

  # Updated Cached Percentile Maps
  def self.set_cached_maps
    @movies = self.active
    %w(plays created_at imdb_rating rotten_critics_score rotten_audience_score).each do |field|
      MovieCache.set_map_cache(field, self.percentile_map(@movies, field))
    end
  end

  # Main Update Function - This should go somewhere else
  def self.fetch_update
    PlatformMovie.fetch_listing
    self.fetch_big_posters
    self.fetch_imdb_info
    self.fetch_rotten_info
    self.fetch_trailer
    PlatformMovie.set_cached_maps
  end

  def self.fetch_imdb_info
    Movie.where(imdb_rating: nil).each do |movie|
      movie.fetch_imdb_info
    end
  end

  def self.fetch_posters
    Movie.where(poster_uid: nil).each do |movie|
      movie.fetch_poster
    end
  end

  def self.fetch_big_posters
    Movie.where(big_poster_uid: nil).each do |movie|
      movie.fetch_big_poster
    end
  end

  def self.fetch_rotten_info
    Movie.where(rotten_critics_score: nil).each do |movie|
      movie.fetch_rotten_info
    end
  end

  def self.fetch_trailer
    Movie.where(youtube_id: nil).each do |movie|
      movie.fetch_trailer
    end
  end

  def fetch_imdb_info
    ImdbWorker.perform_async(self.id)
  end

  def fetch_big_poster
    BigPosterWorker.perform_async(self.id)
  end

  def fetch_poster
    PosterWorker.perform_async(self.id)
  end

  def fetch_rotten_info
    RottenWorker.perform_async(self.id)
  end

  def fetch_trailer
    YoutubeWorker.perform_async(self.id)
  end

  def image_url
    (self.big_poster) ? self.big_poster.remote_url(expires: 1.year.from_now) : nil
  end

  def poster_url
    (self.big_poster) ? self.big_poster.remote_url(expires: 1.year.from_now) : self.image
  end

  def youtube
    'http://www.youtube.com/embed/' + self.youtube_id + '?autoplay=1&origin=http://hbizzle.com' if self.youtube_id
  end

end