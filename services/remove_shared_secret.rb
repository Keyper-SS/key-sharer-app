require 'http'

# Returns an authenticated user, or nil
class RemoveSharedSecret
  def self.call(current_user:, secret_id:, receiver_id:,auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
    .delete("#{ENV['API_HOST']}/users/#{current_user['id']}/owned_secrets/#{secret_id}/share",
    								json:{
    										receiver_id: receiver_id
    									})
    response.code == 201 ? true : false
  end
end