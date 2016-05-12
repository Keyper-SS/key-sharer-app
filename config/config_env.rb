config_env :development, :test do
  set 'MSG_KEY', 'E8DlAZWnN0Sd2Oad0jjTQ9c4TnxRSSL9GhiKE3VQfng='

  set 'API_HOST', 'http://key-sharer-api.herokuapp.com/api/v1'
  set 'APP_HOST', 'http://localhost:9292'
end

config_env :production do
  set 'MSG_KEY', 'fDJvpRnepnLFYu/Xnp/g5d/bWI641RILd+UOeFAF4kM='

  set 'API_HOST', 'http://key-sharer-api.herokuapp.com/api/v1'
  set 'APP_HOST', 'https://key-sharer.herokuapp.com/'
end

config_env do
  set 'SENDGRID_DOMAIN', 'heroku.com'
  set 'SENDGRID_USERNAME', 'app50405591@heroku.com'
  set 'SENDGRID_PASSWORD', 'gus5ozkf2922'
end
