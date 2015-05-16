class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private
	# Confirms a logged-in user.
	def logged_in_user
		unless signed_in?
			flash[:danger] = "Veuillez vous identifier."
			redirect_to signin_path
		end
	end
end
