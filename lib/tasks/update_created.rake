desc "update created time stamps on existing listings"
task update_created: :environment do
  puts "Updating timestamps..."
  xml = Nokogiri::XML(open(Movie::HBO_XML_URL))
  hbo_features = Hash.from_xml(xml.to_s)['response']['body']['productResponses']['featureResponse']
  count = 0
  hbo_features.each do |feature|
    @movie = Movie.where(title: feature['title']).first
    if @movie
      puts "Updating time stamp for: #{@movie.title}"
      @movie.created_at = feature['startDate']
      @movie.save
      count += 1
    end
  end
  p count
end