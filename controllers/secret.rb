require 'sinatra'

# Base class for SharerKey Web Application
class KeySharerApp < Sinatra::Base
  get '/users/:username/secrets/new' do
    slim :new_secret
  end

  post '/users/:username/secrets/new' do
    result = CreateOwnedSecret.call(
        current_user: @current_user, 
        title: params['title'],
        description: params['description'], 
        account: params['account'], 
        password: params['password'])

    if result
      flash[:notice] = 'Secret Added'
    else
      flash[:error] = 'Secret Error. Please try again'
    end
    redirect '/users/params[:username]/secrets/new'
  end

end
