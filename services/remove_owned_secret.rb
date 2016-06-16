
require 'http'

# Returns an authenticated user, or nil
class RemoveOwnedSecret
  def self.call(current_user:, secret_id:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
    .delete("#{ENV['API_HOST']}/users/#{current_user['id']}/owned_secrets/#{secret_id}")
    response.code == 201 ? true : false
  end
end