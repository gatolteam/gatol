module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= Trainer.find_by(auth_token: request.headers['Authorization'])
    @current_user ||= Student.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
  	render json: { errors: "Not authenticated" }, status: 401 unless current_user.present?
  end

end