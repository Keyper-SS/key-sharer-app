require 'sinatra'

# Base class for ConfigShare Web Application
class KeySharerApp < Sinatra::Base
  enable :logging
  use Rack::Session::Cookie, secret: ENV['MSG_KEY']

  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.dirname(__FILE__) + '/../public'
  before do
    @current_user = session[:current_user]
  end

  get '/' do
    slim :home
  end
end
