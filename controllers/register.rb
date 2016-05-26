require 'sinatra'

# This class controlls registration of user in app
class KeySharerApp < Sinatra::Base
  get '/register/?' do
    slim :home
  end

  post '/register/?' do
    begin
      registration = Registration.call(params)

      if registration.failure?
        flash[:error] = 'Please enter a valid username and email'
        redirect 'register'
        halt
      end

      begin
        EmailRegistrationVerification.call(registration)
        flash[:notice] = 'Please Check your email to confirm registration' 
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

    validation = Passwords.call(params)

    if validation.failure?
      flash[:error] = "Uppps.. #{validation.messages.values.join('; ')}"
      redirect "/register/#{params[:token_secure]}/verify"
      halt
    end

    begin
      new_user = SecureMessage.decrypt(params[:token_secure])

      result = CreateVerifiedUser.call(
        username: new_user['username'],
        email: new_user['email'],
        password: validation[:password])

      if result
        flash[:notice] = 'Registration Completed. Please Login'
      else
        flash[:error] = 'Registration error. Please try again'
      end
      redirect '/login'
    rescue => e
      puts "FAIL REGISTRATION: #{e}"
      redirect '/'
    end

  end
end
