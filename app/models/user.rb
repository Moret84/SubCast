class User < ActiveRecord::Base
	validates_presence_of :name, :email, :password
	validates_length_of :password,
		:in => 8..20,
		:too_short => 'password too short',
		:too_long => 'password too long'
	validates_confirmation_of :password
	validates_uniqueness_of :name
	validates_length_of :name,
		:in => 8..20,
		:too_short => 'name too short',
		:too_long => 'name too long'
	validates_format_of :email,
	:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
