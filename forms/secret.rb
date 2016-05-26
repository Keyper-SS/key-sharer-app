require 'dry-validation'


SecretRegistration = Dry::Validation.Form do
	key(:title).required
	key(:account).required
	key(:password).required
end