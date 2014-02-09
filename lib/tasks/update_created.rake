desc "update created time stamps on existing listings"
task update_created: :environment do
  puts "Updating timestamps..."
  xml = Nokogiri::XML(open(Movie::HBO_XML_URL))
  hbo_features = Hash.from_xml(xml.to_s)['response']['body']['productResponses']['featureResponse']
  hbo_features.each do |feature|
    @movie = Movie.where(title: feature['title']).first
    if @movie
      @movie.created_at = feature['startDate']
      @movie.save
    end
  end
end