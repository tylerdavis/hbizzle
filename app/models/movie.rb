class Movie < ActiveRecord::Base

  validates :title, uniqueness: true

  def meta_score
    if (self.imdb_rating && self.rotten_critics_score && self.rotten_audience_score && self.rotten_critics_score > 0 && self.rotten_audience_score > 0)
      return ((self.imdb_rating.to_f*10 + self.rotten_critics_score.to_f + self.rotten_audience_score.to_f) / 3).round
    else
      return 0
    end
  end

  def self.get_ratings
    xml = Nokogiri::XML(open('http://catalog.lv3.hbogo.com/apps/mediacatalog/rest/productBrowseService/HBO/category/INDB487'))
    hbo_features = Hash.from_xml(xml.to_s)['response']['body']['productResponses']['featureResponse']
    hbo_features.each do |feature|
      if self.where(title: feature['title']).blank?
        movie = self.new(
          expire: feature['endDate'],
          hbo_id: feature['TKey'],
          title: feature['title'],
          rating: feature['ratingResponse']['ratingDisplay'],
          summary: feature['summary'],
          year: feature['year'].to_s,
          image: feature['imageResponses'].first['resourceUrl']
        )
        if movie.save
          ImdbWorker.perform_async(movie.id)
        end
      end
    end
  end

  def self.update_rotten
    Movie.all.each do |movie|
      RottenWorker.perform_async(movie.id)
    end
  end

end
