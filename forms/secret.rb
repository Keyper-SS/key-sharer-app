require 'dry-validation'


SecretRegistration = Dry::Validation.Form do
	key(:title).required
	key(:description).required
	key(:account).required
	key(:password).required
end

SecretSharing = Dry::Validation.Form do
	key(:username).required
	key(:secret_id).required
	key(:receiver_email).required
end

SecretRemove = Dry::Validation.Form do
	key(:username).required
	key(:secret_id).required
end