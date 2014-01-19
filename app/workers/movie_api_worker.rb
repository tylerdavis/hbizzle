# class MovieAPIWorker
#   include Sidekiq::Worker

#   def perform(id)
#     @movie = Movie.includes(:actors, :directors).find(id)
#     @actors = @movie.actors
#     @directors = @movie.directors

#     mmapi_movie = MovieAPI.search_by_title(@movie.title)

#     # unless mmapi_movie['code'] == 404
#     @movie.imdb_link = mmapi_movie.first['imdb_url']
#     @movie.imdb_rating = mmapi_movie.first['rating'].to_s

#     mmapi_movie.first['actors'].each do |name|
#       actor = Actor.where(name: name).first || Actor.new(name: name)
#       unless @actors.include? actor
#         @movie.actors << actor
#         actor.save
#       end
#     end

#     mmapi_movie.first['directors'].each do |name|
#       director = Director.where(name: name).first || Director.new(name: name)
#       unless @directors.include? director
#         @movie.directors << director
#         director.save
#       end
#     end
#     # else
#     #   logger.error("MovieAPIWorker - Movie Not Found #{@movie.title}")
#     #   @movie.fetch_imdb_info # Fallback to imdb api
#     # end

#     if @movie.save
#       logger.info("MovieAPIWorker - Updated #{@movie.title}")
#     end
#   end

# end
