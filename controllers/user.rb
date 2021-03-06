require 'sinatra'

# Base class for SharerKey Web Application
class KeySharerApp < Sinatra::Base
  get '/login/?' do
    @gh_url = "#{ENV['GH_SSO_URL']}?client_id=#{ENV['GH_CLIENT_ID']}&scope=#{ENV['GH_SCOPE']}"
    slim :login
  end

  post '/login/?' do
    login = LoginCredentials.call(params)

    if login.failure?
      flash[:error] = 'Username or Password incorrect'
      halt
    end

    user = FindAuthenticatedUser.call(login)

    if user
      @current_user = user['data']['user']
      session[:auth_token] = user['data']['auth_token']
      session[:current_user] = SecureMessage.encrypt(@current_user)
      redirect "/users/#{login[:username]}"
    else
      flash[:error] = 'Your username or password did not match our records'
      slim :login
    end
  end

  get '/logout/?' do
    @current_user = nil
    @gh_url = "#{ENV['GH_SSO_URL']}?client_id=#{ENV['GH_CLIENT_ID']}&scope=#{ENV['GH_SCOPE']}"
    session.clear
    flash[:notice] = 'You have logged out - please login again to use this site'
    slim :login
  end

  get '/users/:username' do
    if @current_user && @current_user['attributes']['username'] == params[:username]
      @auth_token = session[:auth_token]
      @owned = GetOwnedSecrets.call(current_user: @current_user,
                                      auth_token: @auth_token)
      @shared = GetSharedSecrets.call(current_user: @current_user,
                                      auth_token: @auth_token)
      @received = GetReceivedSecrets.call(current_user: @current_user,
                                      auth_token: @auth_token)

      slim(:user)
    else
      slim(:login)
    end
  end

  get '/callback' do
    puts 'Github callback'
    begin
      sso_account = RetrieveGithubAccount.call(params['code'])
      puts 'Account from API'
      puts sso_account
      if sso_account
        login_account(sso_account)
        redirect "/users/#{@current_user['attributes']['username']}"
      else
        'Error getting github account'
        halt
      end
    rescue => e
      flash[:error] = 'Could not sign in using Github'
      puts "RESCUE: #{e}"
      redirect '/login'
    end
  end
end
