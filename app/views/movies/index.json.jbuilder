json.array!(@movies) do |movie|
  json.extract! movie, :title, :rating, :summary, :year, :image_url, :actors_similarity, :directors_similarity, :actors_similarity_rating, :directors_similarity_rating
  json.hbo_link "http://www.hbogo.com/#movies/video&assetID=" + movie.hbo_id + "?videoMode=embeddedVideo"
  json.meta_score movie.meta_score
end
