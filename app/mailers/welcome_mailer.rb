class WelcomeMailer < ApplicationMailer


	def verification_email(user)
		
		@user = user
		@type = 'students'
		if @user.is_trainer?
			@type = 'trainers'
		end
		mail(to: @user.email, subject: 'Verification Email')
		
	end


end
