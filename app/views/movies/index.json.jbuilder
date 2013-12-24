json.array!(@movies) do |movie|
  json.extract! movie, :title, :rating, :summary, :year, :image_url
  json.hbo_link "http://www.hbogo.com/#movies/video&assetID=" + movie.hbo_id + "?videoMode=embeddedVideo"
  json.meta_score movie.meta_score
end
