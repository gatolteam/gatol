class WelcomeMailer < ApplicationMailer


	def verification_email(user, hostname)
		
		@user = user
		@type = 'students'
		if @user.is_trainer?
			@type = 'trainers'
		end
		@hostname = hostname
		mail(to: @user.email, subject: 'Verification Email')
		
	end


end
