require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
  post '/register' do
    email = params[:email]
    username = params[:username]
    password = params[:password]

    @current_user = CreatedUser.call(email: email,
      username: username, password: password)

    if @current_user
      session[:current_user] = @current_user
      puts @current_user
      flash[:info] = "User #{@current_user['data']['attributes']['username']} created"
      slim :home
    else
      flash[:error] = "Error creating user."
      slim :home
    end
  end
end
