require 'sinatra'

# Base class for SharerKey Web Application
class KeySharerApp < Sinatra::Base
  get '/login/?' do
    slim :login
  end

  post '/login/?' do
    username = params[:username]
    password = params[:password]

    @current_user = FindAuthenticatedUser.call(
      username: username, password: password)

    if @current_user
      session[:current_user] = @current_user
      puts @current_user
      slim :home
    else
      # flash[:error] = "Username or Password incorrect"
      slim :login
    end
  end

  get '/logout/?' do
    @current_user = nil
    session[:current_user] = nil
    slim :login
  end

  get '/users/:username' do
    if @current_user && @current_user['data']['attributes']['username'] == params[:username]
      slim(:user)
    else
      slim(:login)
    end
  end
end
