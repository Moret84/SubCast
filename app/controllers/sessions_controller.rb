class SessionsController < ApplicationController
	def new
		@title = "Connexion"
	end

	def create
		user = User.authenticate params[:session][:email_or_username], params[:session][:password]
		if user.nil?
			@title = "Connexion"
			# Crée un message d'erreur et rend le formulaire d'identification.
			flash.now[:danger] = "Mauvais couple identifiant/mot de passe."
			render 'new'
		else
			sign_in user
			redirect_to user
		end
	end

	def destroy
		sign_out if signed_in?
		redirect_to root_url
	end
end
