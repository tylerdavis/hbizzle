ActiveAdmin.register Movie do

  scope :current do
    Movie.order("created_at DESC").where("expire >= ?", Time.now)
  end

  scope :no_youtube do
    Movie.order("created_at DESC").where("youtube_id IS NULL AND expire >= ?", Time.now)
  end

  scope :missing_score do
    Movie.order("created_at DESC").where("imdb_rating IS NULL OR rotten_critics_score IS NULL OR rotten_audience_score IS NULL AND expire >= ?", Time.now)
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
    column :title do |movie|
      link_to movie.title, admin_movie_path(movie)
    end
    column :image do |movie|
      image_tag movie.image_url, style: 'max-width: 100px;'
    end
    column :simple_score
    column :created_at
    column :expire
  end

  show do
    attributes_table do
      row :title
      row :image do
        image_tag movie.image_url, style: 'max-width: 400px;'
      end
      row :trailer do
        if movie.youtube_id.nil?
          link_to_youtube_search movie
        else
          link_to_youtube_video(movie)
        end
      end
      row :year
      row :rating
      row :summary
      row :title
      row :imdb_rating do
        if movie.imdb_rating.nil?
          link_to_google_search(movie, :google)
        else
          movie.imdb_rating
        end
      end
      row :rotten_critics_score do
        if movie.rotten_critics_score.nil?
          link_to_google_search(movie, :rotten_tomatoes)
        else
          movie.rotten_critics_score
        end
      end
      row :rotten_audience_score do
        if movie.rotten_audience_score.nil?
          link_to_google_search(movie, :rotten_tomatoes)
        else
          movie.rotten_audience_score
        end
      end
      row :plays
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs :expire,
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