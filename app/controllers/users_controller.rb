class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :transcribe]
	before_action :correct_user,   only: [:edit, :update]

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

	private

	#Need to say which arguments have to be specified
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	# Confirms a logged-in user.
	def logged_in_user
		unless signed_in?
			flash[:danger] = "Veuillez vous identifier."
			redirect_to signin_path
		end
	end

	# Confirms the correct user.
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end
end
