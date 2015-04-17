class User < ActiveRecord::Base
	has_secure_password

	#Validations
	validates_presence_of :name, :email
	validates_uniqueness_of :name, :email
	validates_length_of :name,
		:in => 1..20,
		:too_short => 'name too short',
		:too_long => 'name too long'
	validates_format_of :email,
	:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
