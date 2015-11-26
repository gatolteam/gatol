class ErrorsController < ApplicationController
  def not_found
  	render "errors/not_found.html.erb", status: 404
  end

  def internal_server_error
  	render "errors/not_found.html.erb", status: 500
  end
end
