json.array!(@movies) do |movie|
  json.extract! movie, :title, :rating, :summary, :year, :image_url
  json.hbo_link 'http://www.hbogo.com/#movies/video&assetID=' + movie.hbo_id + '?videoMode=embeddedVideo'
  json.youtube_id movie.youtube_id if movie.youtube_id
  json.meta_score movie.meta_score
end
