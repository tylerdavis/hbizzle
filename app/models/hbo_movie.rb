class HboMovie < PlatformMovie

  belongs_to :movie

  HBO_XML_URL = 'http://catalog.lv3.hbogo.com/apps/mediacatalog/rest/productBrowseService/HBO/category/INDB487'

  def self.fetch_listing
    xml = Nokogiri::XML(open(HBO_XML_URL))
    hbo_features = Hash.from_xml(xml.to_s)['response']['body']['productResponses']['featureResponse']
    
    hbo_features.each do |feature|

      platform_id = feature['TKey'].strip
      title = feature['title'].strip
      rating = feature['ratingResponse']['ratingDisplay'].strip
      summary = feature['summary'].strip
      year = feature['year'].to_s.strip
      
      started = feature['startDate']
      expires = feature['endDate']

      @movie = Movie.find_or_create_by!(title: title) do |movie|
        movie.rating = rating
        movie.summary = summary
        movie.year = year
      end

      @hbo_movie = HboMovie.find_or_create_by(platform_id: platform_id) do |movie|
        movie.started = started
        movie.expires = expires
        movie.movie_id = @movie.id
      end
      
    end
  end

  def platform_link
    "http://www.hbogo.com/#movies/video&assetID=#{self.platform_id}?videoMode=embeddedVideo"
  end

end