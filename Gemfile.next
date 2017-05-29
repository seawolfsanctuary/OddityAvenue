source 'https://rubygems.org'
ruby '2.4.1', patchlevel: '111'

# Application
# gem 'airbrake', '~> 4.0'  # TODO: upgrade for Rails 5
gem 'rails', '~> 5.1.1'
gem 'puma', '~> 3.7'

# Views
gem 'jquery-rails', '~> 4.3.0'
gem 'tinymce-rails', '~> 4.6.0'

# Models
gem 'pg', '~> 0.18'
gem 'devise', '~> 4.3.0'
gem 'acts-as-taggable-on', '~> 5.0'

# Debugging
group :development, :test do
  gem 'debase'
  gem 'ruby-debug-ide'
end

# Development Tools
group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

# Testing
group :test do
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.6.0'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'db-query-matchers', '~> 0.4.0'
end

# Deployment
group :staging, :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
  gem 'uglifier'
end
