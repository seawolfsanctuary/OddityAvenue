source 'https://rubygems.org'
ruby '2.1.5'

# Application
gem 'airbrake', '~> 4.0'
gem 'rails', '~> 4.2.0'
gem 'puma'

# Views
gem 'jquery-rails', '~> 3.1'
gem 'tinymce-rails', '~> 4.0'

# Models
gem 'pg', '~> 0.18.0'
gem 'devise', '~> 4.0.0'
gem 'acts-as-taggable-on', '~> 3.0'

group :development, :test do
  gem 'debase'
  gem 'ruby-debug-ide'
end

group :test do
  gem 'rspec-rails', '~> 2.14.0'
  gem 'factory_girl', '~> 4.0'
  gem 'db-query-matchers', '~> 0.4.0'
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'uglifier', '>= 2.7.0'
end
