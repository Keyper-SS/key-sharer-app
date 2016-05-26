require 'http'

# Returns an authenticated user, or nil
class CreateOwnedSecret
  def self.call(current_user:, title:, description:, account:, password:)
    response = HTTP.post("#{ENV['API_HOST']}/users/#{current_user['id']}/owned_secrets/",
                         json: { title: title,
                                 description: description,
                                 account: account,
                                 password: password })
    response.code == 201 ? true : false
  end
end