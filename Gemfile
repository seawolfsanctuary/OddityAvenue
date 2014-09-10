source 'https://rubygems.org'
ruby '1.9.3'

gem 'airbrake', '~> 4.0.0'
gem 'rails', '~> 3.2.19'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', '~> 0.15.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'sass-rails',   '~> 3.2.3'
  # gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails', '2.2.1'
gem 'tinymce-rails', '~> 3.5.8.2'

gem 'devise', '~> 2.2.4'

gem 'acts-as-taggable-on', '~> 2.4.1'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :test do
  gem 'rspec-rails', '~> 2.13.1'
  gem 'factory_girl', '~> 4.2.0'
end

group :staging, :production do
  gem 'newrelic_rpm'
end
