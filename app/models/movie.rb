class Movie < ActiveRecord::Base

  attr_accessor :meta_score, :play_rating, :recency_rating

  validates :title, uniqueness: true

  dragonfly_accessor :poster

  HBO_XML_URL = 'http://catalog.lv3.hbogo.com/apps/mediacatalog/rest/productBrowseService/HBO/category/INDB487'

  def self.current
    @movies = Movie.where("expire >= ?", Time.now).order('plays').select {|m| !m.title.downcase.include? 'hbo'}
    @play_map = Movie.plays_percentile_map(@movies)
    @recency_map = Movie.time_delta_percentle_map(@movies)
    @movies.each do |movie|
      movie.set_play_rating(@play_map)
      movie.set_recency_rating(@recency_map)
      movie.set_meta_score
    end
    return @movies
  end

  def self.plays_percentile_map(movies)
    movie_array = movies.map {|m| m.plays}.uniq.sort
    count = movie_array.count
    plays_percentile_map = {}
    movie_array.each_with_index do |play_count, index|
      plays_percentile_map[play_count] = ((index + 1) / count.to_f * 100).round
    end
    return plays_percentile_map
  end

  def self.time_delta_percentle_map(movies)
    movie_array = movies.map {|m| m.created_at}.uniq.sort
    count = movie_array.count
    time_delta_percentle_map = {}
    movie_array.each_with_index do |time_delta, index|
      time_delta_percentle_map[time_delta] = ((index + 1) / count.to_f * 100).round
    end
    return time_delta_percentle_map
  end

  def self.fetch_update
    self.fetch_listing
    self.fetch_posters
    self.fetch_imdb_info
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
      ImdbWorker.perform_async(movie.id)
    end
  end

  def self.fetch_posters
    Movie.where(poster_uid: nil).each do |movie|
      PosterWorker.perform_async(self.id)
    end
  end

  def self.fetch_rotten_info
    Movie.where(rotten_critics_score: nil).each do |movie|
      RottenWorker.perform_async(movie.id)
    end
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
          self.imdb_rating.to_f*10 +
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