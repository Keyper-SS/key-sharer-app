
require 'http'

# Returns an authenticated user, or nil
class RemoveOwnedSecret
  def self.call(current_user:, secret_id:,auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
    .post("#{ENV['API_HOST']}/users/#{current_user['id']}/owned_secrets/#{secret_id}/remove",
                         json: { receiver_email: receiver_email })
    response.code == 201 ? true : false
  end
end