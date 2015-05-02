class UsersController < ApplicationController
	def list
		@users = User.find(:all)
	end

	def show
		@user = User.find(params[:id])
	end

	def new
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

	#Need to say which arguments have to be specified
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
end
