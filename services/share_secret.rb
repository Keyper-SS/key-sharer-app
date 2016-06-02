require 'http'

# Returns an authenticated user, or nil
class ShareSecret
  def self.call(current_user:, secret_id:, receiver_username:,auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
    .post("#{ENV['API_HOST']}/users/#{current_user['id']}/owned_secrets/#{secret_id}/share",
                         json: { receiver_username: receiver_username })
    response.code == 201 ? true : false
  end
end