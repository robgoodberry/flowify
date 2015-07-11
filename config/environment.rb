# Load the Rails application.
require File.expand_path('../application', __FILE__)

Rails.application.configure do
    config.secret_key_base = ENV["SECRET_KEY_BASE"]
end

# Initialize the Rails application.
Rails.application.initialize!
