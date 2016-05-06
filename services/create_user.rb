require 'http'

# Returns an authenticated user, or nil
class CreatedUser

  def self.call(email:,username:, password:)
    redirect = HTTP.post("#{ENV['api']}/users/",
                        json: {username: username, password: password, email: email})
    puts redirect.headers.get("Location")
    response = HTTP.get(redirect.headers.get("Location")[0])
    response.code == 200 ? JSON.parse(response) : nil
  end

end