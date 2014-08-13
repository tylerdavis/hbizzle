ActiveAdmin.register Movie do


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  permit_params :expire,
                :image,
                :imdb_link,
                :imdb_rating,
                :rating,
                :summary,
                :title,
                :year,
                :rotten_critics_score,
                :rotten_audience_score,
                :plays

  index do
    column :title
    column :image do |movie|
      image_tag movie.image_url, style: 'max-width: 100px;'
    end
    column :simple_score do |movie|
      movie.simple_score || 'Missing Data'
    end
    column :created_at
    column :expire
    actions
  end
end
