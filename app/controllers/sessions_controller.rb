class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.authenticate params[:session][:email_or_username], params[:session][:password]
		if user.nil?
			# Crée un message d'erreur et rend le formulaire d'identification.
			flash.now[:error] = "Bad User/Password"
			render 'new'
		else
			sign_in user
			redirect_to user
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
