config_env :development, :test do
  set 'MSG_KEY', '5ogety885Uictrc35VM7ZCZ5sSc1tSg2jB970arhRbs='

  set 'API_HOST', 'http://key-sharer-api.herokuapp.com/api/v1'
  set 'APP_HOST', 'http://localhost:9292'
end

config_env :production do
  set 'MSG_KEY', 'e7yOV3W1KSiNkQuJyptqPOZnbQJi/zWDyVr37qKDcq8='

  set 'API_HOST', 'http://key-sharer-api.herokuapp.com/api/v1'
  set 'APP_HOST', 'http://key-sharer.herokuapp.com'
end

config_env do
  set 'SENDGRID_DOMAIN', 'heroku.com'
  set 'SENDGRID_USERNAME', 'app50405591@heroku.com'
  set 'SENDGRID_PASSWORD', 'gus5ozkf2922'
end
