desc "This task is called by the Heroku scheduler to update the movie listing"
task :fetch => :environment do
  puts "Updating movies..."
  Movie.connection
  Movie.fetch_update
  puts "done."
end