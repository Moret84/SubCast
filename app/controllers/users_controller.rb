class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :transcribe, :do_transcribe]
	before_action :correct_user, only: [:edit, :update]

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
		@user = User.new(user_params)
		if @user.save
			sign_in @user
		else
			render :action => 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to :action => 'show', :id => @user
		else
			render :action => 'edit'
		end
	end

	def delete
		User.find(params[:id]).destroy
		redirect_to :action => 'list'
	end

	def transcribe
		@title = 'Transcrire'
	end

	def do_transcribe
		@title = 'Transcrire'
		flash[:success] = "ajouté avec succès"
		if !params[:file_upload].blank?
			#on uploade le bordel et on le stocke
		end

		if !params[:url].blank?
			if Content.isContent?(params[:url])
				content = Content.create(title: params[:title], description: params[:description], url: params[:url])
				current_user.contents << content
				content.users << current_user
				content.delay.upload
				content.delay.transcribe
				flash.now[:success].prepend("Contenu ")
			elsif Podcast.isPodcast?(params[:url])
				podcast = Podcast.create(rss_link: params[:url])
				current_user.podcasts << podcast
				podcast.users << current_user
				podcast.delay.parse
				flash.now[:success].prepend("Podcast ")
			else
				flash.now[:danger] = "URL invalide"
			end
		end
	end

	private

	#Need to say which arguments have to be specified
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	# Confirms the correct user.
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

end
