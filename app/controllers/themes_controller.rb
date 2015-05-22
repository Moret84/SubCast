class ThemesController < ApplicationController

	def new
		@title = "Abonnement"
		@theme = Theme.new
	end

	def create
		@theme = Theme.new(theme_params)
		if @theme.blank?
			flash.now[:danger] = "Vous n'avez rien entré"
		else
			@theme = Theme.find_by(name: @theme.name) || @theme
			@theme.last_check = DateTime.current
			@theme.save
			current_user.themes << @theme unless current_user.themes.all.include?(@theme)
			current_user.save
			flash.now[:success] = "Vous vous êtes bien abonné au thème " + @theme.name
		end
	end

	private
	#Need to say which arguments have to be specified
	def theme_params
		params.require(:theme).permit(:name)
	end
end
