=begin  TODO: upgrade for Rails 5
Airbrake.configure do |config|
  config.api_key = {:project => 'oddityavenue',                 # the identifier you specified for your project in Redmine
                    :tracker => 'Bug',                          # the name of your Tracker of choice in Redmine
                    :api_key => ENV['HOPTOAD_API_KEY'],         # the key you generated before in Redmine (NOT YOUR HOPTOAD API KEY!)
                    :assigned_to => ENV['HOPTOAD_USERNAME'],    # the login of a user the ticket should get assigned to by default (optional.)
                    :priority => ENV['HOPTOAD_PRIORITY'],       # the default priority (use a number, not a name. optional.)
                    :environment => ENV['RAILS_ENV'],           # application environment, gets prepended to the issue's subject and is stored as a custom issue field. useful to distinguish errors on a test system from those on the production system (optional).
                   }.to_yaml
  config.host = ENV['HOPTOAD_HOSTNAME']                         # the hostname your Redmine runs at
  config.port = ENV['HOPTOAD_PORTNUM']                          # the port your Redmine runs at
  config.secure = (config.port == 443)                          # sends data to your server via SSL (optional.)
end
=end
