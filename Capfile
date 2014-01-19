# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/bundler'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'rvm/capistrano'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

set :rvm_ruby_string, :local

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
