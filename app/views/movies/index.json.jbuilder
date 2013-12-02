json.array!(@movies) do |movie|
  json.extract! movie, :title, :rating, :summary, :year, :imdb_link, :image, :imdb_rating, :rotten_critics_score, :rotten_audience_score
  json.hbo_link "http://www.hbogo.com/#movies/video&assetID=" + movie.hbo_id + "?videoMode=embeddedVideo"
  json.meta_score movie.meta_score
  json.url movie_url(movie, format: :json)
end
