require 'sinatra'
require 'rack-flash'
require 'rack/ssl-enforcer'

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
    if session[:current_user]
      @current_user = SecureMessage.decrypt(session[:current_user])
      @auth_token = session[:auth_token]
      puts @current_user
      puts session[:auth_token]
    end
  end

  def login_account(authorized_account)
    @current_user = authorized_account['account']
    session[:auth_token] = authorized_account['auth_token']
    session[:current_user] = SecureMessage.encrypt(@current_account)
    flash[:notice] = "Welcome back #{@current_user['username']}"
  end

  get '/' do
    slim :home
  end
end
