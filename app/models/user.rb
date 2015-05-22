class User < ActiveRecord::Base
	has_secure_password
	has_and_belongs_to_many :podcasts
	has_and_belongs_to_many :contents
	has_and_belongs_to_many :themes

	#Validations
	validates_presence_of :name, :email
	validates_uniqueness_of :name, :email
	validates_length_of :name,
		:in => 1..20,
		:too_short => 'Nom trop court',
		:too_long => 'Nom trop long'
	validates_format_of :email,
	:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

	validates :password, length: { minimum: 6 }, allow_blank: true

	def self.authenticate email_or_username, password
		user = User.find_by name: email_or_username
		user = User.find_by email: email_or_username if user.nil?
		return nil if user.nil?
		return user if user.try :authenticate, password
	end

	def subscribed?(podcast_id)
		!self.podcasts.find_by(id: podcast_id).nil?
	end
end
