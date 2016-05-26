require 'dry-validation'

LoginCredentials = Dry::Validation.Form do
	key(:username).required
	key(:password).required	
end

Registration = Dry::Validation.Form do 
	key(:username).required
	key(:email).required(format?: /@/)
end

Passwords = Dry::Validation.Form do
	key(:password).required
	key(:password_confirm).required

	rule(password_match?: [:password, :password_confirm]) do |pass1, pass2|
		pass1.eq?(pass2)
	end

	config.messages_file = File.join(__dir__, 'error.yml')
end
