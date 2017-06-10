=begin

Airbrake.configure do |c|
  c.host = "http://redmine.seawolfsanctuary.com/"
  c.environment = ENV['RAILS_ENV']
  c.project_id = 11
  c.project_key = CGI.escape({
    tracker: 'Bug',
    api_key: 'VgAabBoVyXBPjBCDVxBx',
    project: 'oddityavenue'
  }.to_json)
end

=end
