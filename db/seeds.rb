# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = Admin::User.new
u.email = "webmaster@#{Rails.configuration.action_mailer.default_url_options[:host]}"
u.password = "@hangeMe!"
u.save
