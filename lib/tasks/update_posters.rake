desc "migrate images to posters"
task :migrate_posters => :environment do
  puts "Updating posters..."
  Movie.connection
  Movie.all.each do |movie|
    movie.update_poster
    p movie.poster
  end
  puts "done."
end