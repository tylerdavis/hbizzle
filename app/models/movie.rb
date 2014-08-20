class Movie < ActiveRecord::Base

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :directors

  attr_accessor :meta_score, :plays_rating, :created_at_rating, :imdb_rating_rating, :rotten_critics_score_rating, :rotten_audience_score_rating

  validates :title, uniqueness: true
  validates :hbo_id, uniqueness: true

  dragonfly_accessor :big_poster
  dragonfly_accessor :poster

  HBO_XML_URL = 'http://catalog.lv3.hbogo.com/apps/mediacatalog/rest/productBrowseService/HBO/category/INDB487'

  def self.current
    @movies = self.where("expire >= ?", Time.now).order('plays').select {|m| !m.title.downcase.include? 'hbo'}
    @play_map = self.percentile_map(@movies, 'plays')
    @recency_map = self.percentile_map(@movies, 'created_at')
    @imdb_map = self.percentile_map(@movies, 'imdb_rating')
    @rotten_critics_map = self.percentile_map(@movies, 'rotten_critics_score')
    @rotten_audience_map = self.percentile_map(@movies, 'rotten_audience_score')
    @movies.each do |movie|
      movie.set_rating('plays', @play_map)
      movie.set_rating('created_at', @recency_map)
      movie.set_rating('imdb_rating', @imdb_map)
      movie.set_rating('rotten_critics_score', @rotten_critics_map)
      movie.set_rating('rotten_audience_score', @rotten_audience_map)
      movie.set_meta_score
    end
    @movies.select! {|m| m.meta_score > 19}
  end

  def self.latest
    @movies = self.current.select{ |m| m.id > (Movie.last.id - 10) }
  end

  def self.notify_latest
    @movies = Movie.latest.sort! { |a, b| b.meta_score <=> a.meta_score }
    $twitter_client.update("Just added! \"#{@movies.first.title}\" - See more new movies at http://www.hbizzle.com/latest! #hbizzle")
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

  def self.fetch_update
    self.fetch_listing
    self.fetch_posters
    self.fetch_imdb_info
    self.fetch_rotten_info
    self.fetch_trailer
  end

  def self.fetch_listing
    xml = Nokogiri::XML(open(HBO_XML_URL))
    hbo_features = Hash.from_xml(xml.to_s)['response']['body']['productResponses']['featureResponse']
    hbo_features.each do |feature|
      if self.where(hbo_id: feature['TKey']).blank?
        @movie = self.new(
          expire: feature['endDate'],
          hbo_id: feature['TKey'],
          title: feature['title'],
          rating: feature['ratingResponse']['ratingDisplay'],
          summary: feature['summary'],
          year: feature['year'].to_s,
          image: feature['imageResponses'].first['resourceUrl']
        )
        @movie.save
      end
    end
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

  def hbo_link
    "http://www.hbogo.com/#movies/video&assetID=#{self.hbo_id}?videoMode=embeddedVideo"
  end

  def image_url
    (self.poster) ? self.poster.remote_url(expires: 1.year.from_now) : self.image
  end

  def poster_url
    (self.big_poster) ? self.big_poster.remote_url(expires: 1.year.from_now) : self.image
  end

  def youtube
    'http://www.youtube.com/embed/' + self.youtube_id + '?autoplay=1&origin=http://hbizzle.com' if self.youtube_id
  end

  def simple_score
    (self.rotten_critics_score && self.rotten_audience_score && self.imdb_rating) ?
      ((self.rotten_critics_score.to_f + self.rotten_audience_score.to_f + (self.imdb_rating.to_f * 10)) / 3).round :
      false
  end

  def play
    self.plays += 1
  end

  def set_meta_score
    if self.imdb_rating && self.rotten_critics_score && self.rotten_audience_score
      self.meta_score = (
        (
          self.imdb_rating_rating +
          self.rotten_critics_score_rating + 
          self.rotten_audience_score_rating +
          self.plays_rating +
          self.created_at_rating * 1.2
        ) / 5
      ).round
    else
      self.meta_score = 0
    end
  end

  def set_rating(value, percentile_map)
    self.instance_variable_set("@#{value.to_s}_rating", percentile_map[self[value].to_f])
  end

end