require 'http'

# Returns owned Secres
class GetSharedSecrets
  def self.call(current_user:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/users/#{current_user['id']}/shared_secrets")
    response.code == 200 ? extract_secrets(response.parse) : []
  end

  private

  def self.extract_secrets(secrets)
    secrets['data'].map do |secret|
      { id: secret['secret_id'],
        title: secret['data']['title'],
        description: secret['data']['description'],
        account: secret['data']['account'],
        password: secret['data']['password'],
        receiver_id: secret['receiver_id'],
        receiver_username: secret['receiver_username'],
        receiver_email: secret['receiver_email']}
    end
  end
end