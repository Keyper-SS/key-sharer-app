# require 'config_env'
Dir.glob('./{config,lib,services,views,controllers}/init.rb').each do |file|
  require file
end

# ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")

run KeySharerApp
