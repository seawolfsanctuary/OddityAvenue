# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

require 'securerandom'

%w{secret_token secret_key_base}.each do |key|
  ENV[key] = SecureRandom.hex(64) unless ENV[key].present?
  OddityAvenue::Application.config.send("#{key}=".to_sym, ENV[key])
end