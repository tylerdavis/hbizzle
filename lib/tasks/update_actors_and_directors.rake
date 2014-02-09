desc "update actors and directors on existing listings"
task update_casts: :environment do
  
  puts "Updating cast..."

  @actors = Actor.all
  @directors = Director.all
  
  Movie.all.each do |movie|
    imdb_movies = Imdb::Movie.search(movie.title)
    # imdb_movie = imdb_movies.select { |m| m.title.include? movie.year }.first
    imdb_movie = imdb_movies.first
    if imdb_movie

      # Directors
      imdb_movie.director.each do |name|
        director = Director.where(name: name).first || Director.new(name: name)
        unless @directors.include? director
          movie.directors << director
          director.save
        end
      end

      # Cast
      imdb_movie.cast_members.each do |name|
        actor = Actor.where(name: name).first || Actor.new(name: name)
        unless @actors.include? actor
          movie.actors << actor
          actor.save
        end
      end
    end
  end
end