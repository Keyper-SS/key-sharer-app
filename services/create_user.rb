require 'http'

# Returns an authenticated user, or nil
class CreatedUser
  HOST = 'http://localhost:3000/api/v1'

  def self.call(email:,username:, password:)
    redirect = HTTP.post("#{HOST}/users/",
                        json: {username: username, password: password, email: email})
    response = HTTP.get(redirect.headers.get("Location")[0])
    response.code == 200 ? JSON.parse(response) : nil
  end

end