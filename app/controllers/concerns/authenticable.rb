module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= Trainer.find_by(auth_token: request.headers['Authorization'])
  end
end