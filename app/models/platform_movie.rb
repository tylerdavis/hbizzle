class PlatformMovie < ActiveRecord::Base
  belongs_to :movie

  scope :active, -> { where("expires >= ?", Time.now) }

  attr_accessor :meta_score, :plays_rating, :started_rating, :imdb_rating_rating, :rotten_critics_score_rating, :rotten_audience_score_rating

  def self.current
    play_map = MovieCache.get_cached_map('plays')
    recency_map = MovieCache.get_cached_map('started')
    imdb_map = MovieCache.get_cached_map('imdb_rating')
    rotten_critics_map = MovieCache.get_cached_map('rotten_critics_score')
    rotten_audience_map = MovieCache.get_cached_map('rotten_audience_score')

    movies = self.includes(:movie).active
    movies.each do |movie|
      movie.set_started_rating(recency_map)
      movie.set_rating('plays', play_map)
      movie.set_rating('imdb_rating', imdb_map)
      movie.set_rating('rotten_critics_score', rotten_critics_map)
      movie.set_rating('rotten_audience_score', rotten_audience_map)
      movie.set_meta_score
    end
    movies
  end

  def self.latest
    movies = self.current.sort_by { |m| m.created_at }.reverse
    latest_movies = movies.select { |m| m.created_at == movies.first.created_at }
    latest_movies.sort_by! { |m| m.meta_score }.reverse
  end

  def self.notify_latest
    @movies = self.latest
    if Rails.env.production?
      $twitter_client.update("Just added! \"#{@movies.first.title}\" - See more new movies at http://www.hbizzle.com/latest! #hbizzle")
    end
  end

  def simple_score
    (self.rotten_critics_score && self.rotten_audience_score && self.imdb_rating) ?
      ((self.rotten_critics_score.to_f + self.rotten_audience_score.to_f + (self.imdb_rating.to_f * 10)) / 3).round :
      false
  end

  def play!
    self.plays += 1
    self.save
  end

  def set_meta_score
    if self.movie.imdb_rating && self.movie.rotten_critics_score && self.movie.rotten_audience_score
      self.meta_score = (
        (
          self.imdb_rating_rating +
          self.rotten_critics_score_rating + 
          self.rotten_audience_score_rating +
          self.plays_rating +
          self.started_rating * 1.2
        ) / 5
      ).round
    else
      self.meta_score = 0
    end
  end

  def set_rating(value, percentile_map)
    self.instance_variable_set("@#{value.to_s}_rating", percentile_map[self.movie[value].to_f.to_s].to_i)
  end

  def set_started_rating(percentile_map)
    self.instance_variable_set("@started_rating", percentile_map[self.started.to_f.to_s].to_i)
  end

  def self.percentile_map(movies, action)
    movie_array = movies.map {|m| m[action].to_f}.uniq.sort
    count = movie_array.count
    percentile_map = {}
    movie_array.each_with_index do |key, index|
      percentile_map[key] = ((index + 1) / count.to_f * 100).round
    end
    return percentile_map
  end

  # Updated Cached Percentile Maps
  def self.set_cached_maps
    
    # Set the started percentile map based on the platform movie
    @platform_movies = self.active
    MovieCache.set_map_cache(:started, self.percentile_map(@platform_movies, :started))

    # All other maps are based on the base movies data
    @movies = @platform_movies.map { |m| m.movie }
    %w(plays imdb_rating rotten_critics_score rotten_audience_score).each do |field|
      MovieCache.set_map_cache(field, self.percentile_map(@movies, field))
    end
  end

end
