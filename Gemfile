source 'https://rubygems.org'
ruby '2.1.5'

# Application
gem 'airbrake', '~> 4.0.0'
gem 'rails', '~> 4.0.0'
gem 'protected_attributes'  # TODO: temp while upgrading to Rails 4
gem 'unicorn'

# Views
gem 'jquery-rails', '2.2.1'
gem 'tinymce-rails', '~> 3.5.8.2'

# Models
gem 'pg', '~> 0.15.1'
gem 'devise', '~> 3.0.0'
gem 'acts-as-taggable-on', '~> 2.4.1'

group :test do
  gem 'rspec-rails', '~> 2.13.1'
  gem 'factory_girl', '~> 4.2.0'
end

group :staging, :production do
  gem 'newrelic_rpm'
  gem 'uglifier', '>= 1.0.3'
end