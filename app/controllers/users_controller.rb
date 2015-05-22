class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :transcribe, :show, :unsubscribe]
	before_action :correct_user, only: [:edit, :update, :show, :unsubscribe ]

	def list
		@users = User.find(:all)
	end

	def show
		@user = User.find(params[:id])
		@title = "Profil de " + @user.name
	end

	def new
		@title = "Inscription"
		@user = User.new
	end

	def create
		user = User.new(user_params)
		if user.save
			sign_in user
			flash[:success] = "Bienvenue dans SubCast"
			redirect_back_or user

		else
			@title = "Inscription"
			render :action => 'new'
		end
	end

	def edit
		@title = "Modifier Profil"
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Profil mis à jour"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def delete
		User.find(params[:id]).destroy
		redirect_to :action => 'list'
	end

	def transcribe
		@title = 'Transcrire'
		@content = Content.new
		@podcast = Podcast.new
	end

	def unsubscribe
		if params.has_key?(:kind) and params.has_key?(:object_id)
			if params[:kind] == "theme"
				unsuscribe_from_theme params[:object_id]
			elsif params[:kind] == "podcast"
				unsuscribe_from_podcast params[:object_id]
			end
		end
		render nothing: true
	end

	private

	def unsuscribe_from_theme theme_id
		theme = current_user.themes.find(theme_id)
		if !theme.nil?
			current_user.themes.delete(theme)
			current_user.save
		end
		theme = Theme.find(theme_id)
		if theme.nil?
			theme.destroy
		end
	end

	def unsuscribe_from_podcast podcast_id
		podcast = current_user.podcasts.find(podcast_id)
		if !podcast.nil?
			current_user.podcasts.delete(podcast)
			current_user.save
		end
		podcast = Podcast.find(podcast_id)
		if podcast.nil?
			podcast.destroy
		end
	end

	#Need to say which arguments have to be specified
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	# Confirms the correct user.
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

	def logged_in_user
		unless signed_in?
			store_location
			flash[:danger] = "Please log in."
			redirect_to login_url
		end
	end


end
