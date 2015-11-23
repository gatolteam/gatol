class WelcomeMailer < ApplicationMailer


	def verification_email(user)
		
		@user = user
		@type = 'students'
		if @user.is_trainer?
			@type = 'trainers'
		end
		mail(to: @user.email, subject: 'Game-a-thon of Learning: Verification Email')
		
	end


	def reset_password_email(user, pw)

		@user = user
		@new_pass = pw
		mail(to: @user.email, subject: 'Game-a-thon of Learning: New Password')

	end



	def game_invitation_email(email_address, user, game)
		@user = user
		@game = game
		mail(to: email_address, subject: 'Game-a-thon of Learning: Game Invitation')
	end


end
