config_env :development,:test do
  set 'api', 'http://localhost:3000/api/v1'
end

config_env :production do 
	set 'api', 'http://key-sharer-api.herokuapp.com/api/v1'
end

