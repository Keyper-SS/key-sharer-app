require 'http'

# Returns an authenticated user, or nil
class RetrieveGithubAccount
  def self.call(code)
  	code = SecureMessage.sign({code: code})
    response = HTTP.headers(accept: 'application/json')
                   .get("#{ENV['API_HOST']}/github_account?code=#{code}")
    response.code == 200 ? JSON.parse({ :data => JSON.parse(response) }.to_json) : nil
  end
end
