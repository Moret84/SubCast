class TcMailer < ApplicationMailer
	def transcribed_content(user, content)
		@user = user
		@content = content
		mail(to: @user.email, subject: 'Your content has been transcribed')
	end
end
