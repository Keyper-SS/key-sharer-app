require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedUser
  def self.call(username:, password:)
  	signed_request = SecureMessage.sign({
              	username: username,
              	password: password
              })
    response = HTTP.post("#{ENV['API_HOST']}/users/authenticate",
    										body: signed_request)
    response.code == 200 ? JSON.parse({ :data => JSON.parse(response) }.to_json) : nil
  end

end
