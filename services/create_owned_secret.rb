require 'http'

# Returns an authenticated user, or nil
class CreateOwnedSecret
  def self.call(current_user:, title:, description:, account:, password:, auth_token:)
  	puts 'Creating secret'
  	puts "#{current_user}-#{title}-#{description}-#{account}-#{password}-#{auth_token}"
    response = HTTP.auth("Bearer #{auth_token}")
    .post("#{ENV['API_HOST']}/users/#{current_user['id']}/owned_secrets/",
                         json: { title: title,
                                 description: description,
                                 account: account,
                                 password: password })
    response.code == 202 ? true : false
  end
end