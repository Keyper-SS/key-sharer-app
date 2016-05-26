require 'sinatra'
require 'rack-flash'

# Base class for ConfigShare Web Application
class KeySharerApp < Sinatra::Base
  enable :logging

  use Rack::Session::Cookie, secret: ENV['MSG_KEY'],
                             expire_after: 60 * 60 * 24 * 7
  use Rack::Flash

  configure :production do
    use Rack::SslEnforcer
  end
  
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.dirname(__FILE__) + '/../public'

  before do
    puts 'Session'
    puts session[:current_user]
    if session[:current_user]
      puts 'Setting session '

      @current_user = SecureMessage.decrypt(session[:current_user])
      puts @current_user
    end
  end

  get '/' do
    slim :home
  end
end
