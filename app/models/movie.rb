class Movie < ActiveRecord::Base

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :directors

  attr_accessor :meta_score, :play_rating, :recency_rating

  validates :title, uniqueness: true

  dragonfly_accessor :poster

  HBO_XML_URL = 'http://catalog.lv3.hbogo.com/apps/mediacatalog/rest/productBrowseService/HBO/category/INDB487'

  def self.current
    @movies = Movie.where("expire >= ?", Time.now).order('plays').select {|m| !m.title.downcase.include? 'hbo'}
    @play_map = Movie.percentile_map(@movies, 'plays')
    @recency_map = Movie.percentile_map(@movies, 'created_at')
    @movies.each do |movie|
      movie.set_play_rating(@play_map)
      movie.set_recency_rating(@recency_map)
      movie.set_meta_score
    end

  end

  def self.percentile_map(movies, action)
    movie_array = movies.map {|m| m[action]}.uniq.sort
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
    self.fetch_mmapi_info
    self.fetch_rotten_info
  end

  def self.fetch_listing
    xml = Nokogiri::XML(open(HBO_XML_URL))
    hbo_features = Hash.from_xml(xml.to_s)['response']['body']['productResponses']['featureResponse']
    hbo_features.each do |feature|
      if self.where(title: feature['title']).blank?
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

  def self.fetch_mmapi_info
    Movie.all.where(imdb_rating: nil).each do |movie|
      movie.fetch_mmapi_info
    end
  end

  def self.fetch_posters
    Movie.where(poster_uid: nil).each do |movie|
      movie.fetch_poster
    end
  end

  def self.fetch_rotten_info
    Movie.where(rotten_critics_score: nil).each do |movie|
      movie.fetch_rotten_info
    end
  end

  def fetch_imdb_info
    ImdbWorker.perform_async(self.id)
  end

  def fetch_mmapi_info
    MovieAPIWorker.perform_async(self.id)
  end

  def fetch_poster
    PosterWorker.perform_async(self.id)
  end

  def fetch_rotten_info
    RottenWorker.perform_async(self.id)
  end

  def hbo_link
    return "http://www.hbogo.com/#movies/video&assetID=#{self.hbo_id}?videoMode=embeddedVideo"
  end

  def image_url
    self.poster.remote_url
  end

  def play
    self.plays += 1
  end

  def set_meta_score
    if (self.imdb_rating && self.rotten_critics_score && self.rotten_audience_score)
      self.meta_score = (
        (
          self.imdb_rating.to_f * 10 +
          self.rotten_critics_score.to_f + 
          self.rotten_audience_score.to_f +
          self.play_rating +
          self.recency_rating * 1.2
        ) / 5
      ).round
    else
      self.meta_score = 0
    end
  end

  def set_play_rating(plays_percentile_map)
    self.play_rating = plays_percentile_map[self.plays]
  end

  def set_recency_rating(time_delta_percentle_map)
    self.recency_rating = time_delta_percentle_map[self.created_at]
  end

end