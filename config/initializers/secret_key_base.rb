# Provide a fallback secret_key_base so the app boots without config/master.key.
# In production, set the SECRET_KEY_BASE environment variable to a long random string.
Rails.application.config.secret_key_base ||=
  ENV.fetch("SECRET_KEY_BASE", "dev_secret_key_base_change_me_please_0000000000000000")
