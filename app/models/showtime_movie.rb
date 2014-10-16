class ShowtimeMovie < PlatformMovie
  belongs_to :movie

  XML_URL = 'http://www.showtimeanytime.com/tve/xml/category?categoryid=448'

  def self.fetch_listing
    features = Nokogiri::XML(open(XML_URL)).css('Title[type="Movie"]')
    features.each do |feature|
      platform_id = feature['titleid']
      title = feature.css('title').first.text.strip
      rating = feature.css('rating').first.text.strip
      summary = feature.css('description').first.text.strip
      year = feature.css('releaseYear').first.text

      started = DateTime.strptime(feature.css('startTime').first.text, '%m/%d/%Y %H:%M%p')
      expires = DateTime.strptime(feature.css('endTime').first.text, '%m/%d/%Y %H:%M%p')

      @movie = Movie.find_or_create_by!(title: title) do |movie|
        movie.rating = rating
        movie.summary = summary
        movie.year = year
      end

      @showtime_movie = ShowtimeMovie.find_or_create_by(platform_id: platform_id) do |movie|
        movie.started = started
        movie.expires = expires
        movie.movie_id = @movie.id
      end

    end
  end

  def platform_link
    "http://www.showtimeanytime.com/#/movie/#{self.platform_id}"
  end

end