require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret ENV['DRAGONFLY_SECRET']

  url_format "/media/:job/:name"

  datastore :s3,
    bucket_name: ENV['AWS_BUCKET'],
    access_key_id: ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    url_host: 'dsbu8p9bw9q44.cloudfront.net'

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
