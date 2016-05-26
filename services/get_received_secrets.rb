require 'http'

# Returns owned Secres
class GetReceivedSecrets
  def self.call(current_user:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/users/#{current_user['id']}/received_secrets")
    response.code == 200 ? extract_secrets(response.parse) : []
  end

  private

  def self.extract_secrets(secrets)
    secrets['data'].map do |secret|
      { id: secret['id'],
        title: secret['data']['title'],
        description: secret['data']['description'],
        account: secret['data']['account_encrypted'],
        password: secret['data']['password_encrypted'] }
    end
  end
end