
require 'http'

# Returns an authenticated user, or nil
class CreateVerifiedUser
  def self.call(username:, email:, password:)
  	signed_request = SecureMessage.sign(
  											{ username: username,
                                 email: email,
                                 password: password }
                                 )
    response = HTTP.post("#{ENV['API_HOST']}/users/",
                         body: signed_request)
    response.code == 201 ? true : false
  end
end
