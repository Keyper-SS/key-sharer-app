require 'sinatra'

# This class controlls registration of user in app
class KeySharerApp < Sinatra::Base
  get '/register/?' do
    slim :home
  end

  post '/register/?' do
    begin
      puts params[:username]
      puts params[:email]

      registration = Registration.call(params)

      if registration.failure?
        flash[:error] = 'Please enter a valid username and email'
        redirect 'register'
        halt
      end

      begin
        EmailRegistrationVerification.call(registration)
        redirect '/'
      rescue => e
        logger.error "FAIL EMAIL: #{e}"
        flash[:error] = 'Unable to send email verification -- please '\
                        'check you have entered the right address'
        redirect '/register'
      end
    rescue => e
      puts "FAIL EMAIL: #{e}"
      redirect '/register'
    end
  end

  get '/register/:token_secure/verify' do
    @token_secure = params[:token_secure]
    @new_user = SecureMessage.decrypt(@token_secure)

    slim :register_confirm
  end

  post '/register/:token_secure/verify' do
    redirect "/register/#{params[:token_secure]}/verify" unless
      (params[:password] == params[:password_confirm]) &&
      !params[:password].empty?

    new_user = SecureMessage.decrypt(params[:token_secure])

    result = CreateVerifiedUser.call(
      username: new_user['username'],
      email: new_user['email'],
      password: params['password'])

    puts "RESULT: #{result}"
    result ? redirect('/login') : redirect('/register')
  end
end
