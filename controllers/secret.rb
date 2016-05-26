require 'sinatra'

# Base class for SharerKey Web Application
class KeySharerApp < Sinatra::Base
  get '/users/:username/secrets/new' do
    slim :new_secret
  end

  post '/users/:username/secrets/new' do
    secret = SecretRegistration.call(params)

    if secret.failure?
      flash[:error] = 'Some input is required. Please try again'
      redirect "/users/params[:username]/secrets/new"
      halt
    end

    result = CreateOwnedSecret.call(
        current_user: @current_user, 
        title: secret[:title],
        description: secret[:description], 
        account: secret[:account], 
        password: secret[:password])

    if result
      flash[:notice] = 'Secret Added'
    else
      flash[:error] = 'Secret Error. Please try again'
    end
    redirect '/users/params[:username]/secrets/new'
  end

end
