desc "migrate images to posters"
task migrate_posters: :environment do
  puts "Updating posters..."
  Movie.connection
  Movie.all.each do |movie|
    movie.fetch_poster
  end
end