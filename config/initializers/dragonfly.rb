require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "9e3dcf213f38eea3486f6ba6891a029e5a49ce1a2f588766ab82f46fa211f188"

  url_format "/media/:job/:name"

  if Rails.env.development?
    datastore :file,
              root_path: Rails.root.join('public/system/dragonfly', Rails.env),
              server_root: Rails.root.join('public')
  elsif Rails.env.production?
    datastore :s3,
              bucket_name: ENV['AWS_BUCKET'],
              access_key_id: ENV['AWS_ACCESS_KEY'],
              secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
              url_host: 'dsbu8p9bw9q44.cloudfront.net'
  end

end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
