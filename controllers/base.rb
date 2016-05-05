require 'sinatra'
require 'sinatra/flash'

# Basec class for ConfigShare Web Application
class KeySharerApp < Sinatra::Base
  use Rack::Session::Cookie, expire_after: 2_592_000 # One month in seconds
  register Sinatra::Flash
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.dirname(__FILE__) + '/../public'

  before do
    @current_user = session[:current_user]
  end

  get '/' do
    slim :home
  end
end