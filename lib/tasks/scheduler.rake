desc "This task is called by the Heroku scheduler to update the movie listing"
task :update_listing => :environment do
  puts "Updating movies..."
  Movie.get_ratings
  Movie.update_rotten
  puts "done."
end