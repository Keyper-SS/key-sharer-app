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
      redirect "/users/#{params[:username]}/secrets/new"
      halt
    end

    result = CreateOwnedSecret.call(
        current_user: @current_user, 
        title: secret[:title],
        description: secret[:description], 
        account: secret[:account], 
        password: secret[:password],
        auth_token: @auth_token)

    if result
      flash[:notice] = 'Secret Added'
    else
      flash[:error] = 'Secret Error. Please try again'
    end
    redirect "/users/#{params[:username]}/secrets/new"
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
        redirect "/users/#{params[:username]}/secrets/#{params[:secret_id]}/share"
        halt
      end


      result = ShareSecret.call(
          current_user: @current_user, 
          secret_id: sharingForm[:secret_id],
          receiver_email: sharingForm[:receiver_email], 
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

  post '/users/:username/secrets/:secret_id/removeOwned' do
    # Remove Secret
    if @current_user && @current_user['attributes']['username'] == params[:username]
      parameters = SecretRemove.call(params)

      if parameters.failure?
        flash[:error] = 'Some input is required. Please try again'
        redirect "/users/#{params[:username]}"
        halt
      end


      if RemoveOwnedSecret.call(current_user: @current_user,secret_id: parameters[:secret_id], auth_token: @auth_token )
        flash[:notice] = 'Secret Removed'
        redirect "/users/#{parameters[:username]}"
      else
        flash[:error] = 'Could not remove Secret'
        redirect "/users/#{parameters[:username]}"
      end
    else
      flash[:error] = 'You are not authorized to do this'
      redirect('/')
    end
    
  end

  post '/users/:username/secrets/:secret_id/:receiver_id/removeShared' do
    # Remove Secret
    if @current_user && @current_user['attributes']['username'] == params[:username]
      parameters = SecretSharedRemove.call(params)
      if parameters.failure?
        flash[:error] = 'Some input is required. Please try again'
        redirect "/users/#{params[:username]}"
        halt
      end

      if RemoveSharedSecret.call(current_user: @current_user,secret_id: parameters[:secret_id], receiver_id: parameters[:receiver_id], auth_token: @auth_token )
        flash[:notice] = 'Secret Removed'
        redirect "/users/#{parameters[:username]}"
      else
        flash[:error] = 'Could not remove Secret'
        redirect "/users/#{parameters[:username]}"
      end
    else
      flash[:error] = 'You are not authorized to do this'
      redirect('/')
    end
    
  end

end
