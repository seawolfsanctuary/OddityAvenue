source 'https://rubygems.org'
ruby '2.1.5'

# Application
gem 'airbrake', '~> 4.0.0'
gem 'rails', '~> 4.0.0'
gem 'unicorn'

# Views
gem 'jquery-rails', '~> 3.1.2'
gem 'tinymce-rails', '~> 4.1.6'

# Models
gem 'pg', '~> 0.18.1'
gem 'devise', '~> 3.0.0'
gem 'acts-as-taggable-on', '~> 3.4.3'

group :test do
  gem 'rspec-rails', '~> 2.14.2'
  gem 'factory_girl', '~> 4.5.0'
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'uglifier', '>= 2.7.0'
end