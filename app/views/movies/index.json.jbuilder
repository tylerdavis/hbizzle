json.array!(@movies) do |movie|
  json.extract! movie.movie, :title, :rating, :summary, :year, :poster_url
  if movie.type == 'HboMovie'
    json.provider 'hbo'
  elsif movie.type == 'ShowtimeMovie'
    json.provider 'showtime'
  end
  json.started movie.started
  json.expires movie.expires
  json.youtube_id movie.movie.youtube_id
  json.meta_score movie.meta_score
end
