module SessionsHelper
	def sign_in(user)
		session[:user_id] = user.id
	end

	# Redirects to stored location (or to the default).
	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	# Stores the URL trying to be accessed.
	def store_location
		session[:forwarding_url] = request.url if request.get?
	end

	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		session.delete(:user_id)
		@current_user = nil
	end

	def current_user?(user)
		user == current_user
	end
end
