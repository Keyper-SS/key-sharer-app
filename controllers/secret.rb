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

  get '/users/:username/secrets/:secret_id/share' do
    @secret_id = params["secret_id"]
    slim :share_secret
  end

  post '/users/:username/secrets/:secret_id/share' do
    if @current_user && @current_user['attributes']['username'] == params[:username]
  
      sharingForm = SecretSharing.call(params)

      if sharingForm.failure?
        flash[:error] = 'Some input is required. Please try again'
        redirect "/users/params[:username]/secrets/new"
        halt
      end


      puts 'info to call'
      puts @current_user
      puts sharingForm[:secret_id]
      puts sharingForm[:receiver_username]
      puts @auth_token

      result = ShareSecret.call(
          current_user: @current_user, 
          secret_id: sharingForm[:secret_id],
          receiver_username: sharingForm[:receiver_username], 
          auth_token: @auth_token)

      if result
        flash[:notice] = 'Secret Shared'
      else
        flash[:error] = 'Secret Error. Please try again'
      end
      redirect "/users/#{params[:username]}"
    else
      slim(:login)
    end
  end

end
