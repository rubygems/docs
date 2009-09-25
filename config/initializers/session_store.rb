# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_docs.rubygems.org_session',
  :secret      => '647b2adcfa29af3cd0ac52f1cf65ee53e60eebf9d9b4b9bddaa80ee6e1ba5d79e87848d612ed44632e03766160a391ac4b4cea4d4ee21ece9bcc8d37d3dc4ab4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
