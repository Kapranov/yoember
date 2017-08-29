class ErrorsController < ApplicationController
  def not_found
    render json: { errors: ["Not Found"]}.to_json, status: 404
  end

  def unacceptable
    render json: { errors: ["Unprocessable Entity"]}.to_json, status: 422
  end

  def internal_server_error
    render json: { errors: ["Internal Server Error"]}.to_json, status: 500
  end
end
