ActiveAdmin.register Movie do


  scope :all do
    Movie.all
  end

  scope :current do
    Movie.where("expire >= ?", Time.now).sort_by { |movie| movie.created_at }.reverse!
  end

  scope :no_youtube do
    Movie.where("youtube_id IS NULL AND expire >= ?", Time.now).sort_by { |movie| movie.created_at }.reverse!
  end

  scope :missing_score do
    Movie.where("imdb_rating IS NULL OR rotten_critics_score IS NULL OR rotten_audience_score IS NULL AND expire >= ?", Time.now).sort_by { |movie| movie.created_at }.reverse!
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
                :youtube

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
        image_tag movie.image_url
      end
      row :trailer do
        link_to 'Trailer', "https://www.youtube.com/watch?v=#{movie.youtube_id}" if movie.youtube_id.present?
      end
      row :year
      row :rating
      row :summary
      row :title
      row :imdb_rating
      row :rotten_critics_score
      row :rotten_audience_score
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
