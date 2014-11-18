ActiveAdmin.register PlatformMovie do

  scope :current do
    PlatformMovie.order("started DESC").active
  end

  scope :hbo do
    HboMovie.order("started DESC").active
  end

  scope :showtime do
    ShowtimeMovie.order("started DESC").active
  end

  scope :no_youtube do
    PlatformMovie.joins(:movie).merge(Movie.where(youtube_id: nil))
  end

  scope :missing_score do
    PlatformMovie.joins(:movie).merge(Movie.where("imdb_rating IS NULL OR rotten_critics_score IS NULL OR rotten_audience_score IS NULL"))
  end

  permit_params :expire,
                :imdb_rating,
                :rating,
                :summary,
                :title,
                :year,
                :rotten_critics_score,
                :rotten_audience_score,
                :plays,
                :youtube_id

  index do
    column :title do |pm|
      link_to pm.movie.title, admin_platform_movie_path(pm)
    end
    column :image do |pm|
      image_tag pm.movie.image_url, style: 'max-height: 60px;'
    end
    column :type
    column :simple_score
    column :started
    column :expires
    column :tweet do |pm|
      link_to 'Tweet!', tweet_update_path(pm), data: { confirm: "Are you sure you really want to tweet about #{pm.movie.title}?" }
    end
  end

  show do |pm|
    attributes_table do
      row :title do |pm|
        pm.movie.title
      end
      row :image do
        image_tag pm.movie.image_url, style: 'max-width: 400px;'
      end
      row :trailer do
        if pm.movie.youtube_id.nil?
          link_to_youtube_search pm.movie
        else
          link_to_youtube_video(pm.movie)
        end
      end
      row :year do |pm|
        pm.movie.year
      end
      row :rating do |pm|
        pm.movie.rating
      end
      row :summary do |pm|
        pm.movie.summary
      end
      row :imdb_rating do
        if pm.movie.imdb_rating.nil?
          link_to_google_search(pm.movie, :google)
        else
          pm.movie.imdb_rating
        end
      end
      row :rotten_critics_score do
        if pm.movie.rotten_critics_score.nil?
          link_to_google_search(pm.movie, :rotten_tomatoes)
        else
          pm.movie.rotten_critics_score
        end
      end
      row :rotten_audience_score do
        if pm.movie.rotten_audience_score.nil?
          link_to_google_search(movie, :rotten_tomatoes)
        else
          pm.movie.rotten_audience_score
        end
      end
      row :plays
      row :tweet do |pm|
        link_to 'Tweet!', tweet_update_path(pm), data: { confirm: "Are you sure?" }
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs :expires,
             :imdb_link,
             :imdb_rating,
             :rating,
             :summary,
             :title,
             :year,
             :rotten_critics_score,
             :rotten_audience_score,
             :youtube_id
    f.actions
  end

end

def link_to_google_search(movie, provider)
  link_to 'Find on Google', "http://www.google.com/search?ie=UTF-8&q=#{provider.to_s.gsub('_', ' ')} #{movie.title}", :target => "_blank"
end

def link_to_youtube_search(movie)
  link_to 'Find on Youtube', "https://www.youtube.com/results?search_query=#{movie.title} trailer", :target => "_blank"
end

def link_to_youtube_video(movie)
  link_to 'Trailer', "https://www.youtube.com/watch?v=#{movie.youtube_id}", :target => "_blank"
end