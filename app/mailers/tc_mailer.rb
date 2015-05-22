class TcMailer < ApplicationMailer
	def transcribed_content(user, content)
		@user = user
		@content = content
		mail(to: @user.email, subject: 'Votre contenu a été transcrit !')
	end

	def transcribed_content_in_podcast(user, content)
		@user = user
		@content = content
		mail(to: @user.email, subject: 'Votre contenu a été transcrit !')
	end

	def new_content_released(user, theme, news)
		@user = user
		@news = news
		@theme = theme
		mail(to: @user.email, subject: @theme.name + ' : De nouveaux contenus sont disponibles !')
	end
end
