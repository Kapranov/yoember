class ErrorsController < ApplicationController
  def not_found
    json_response(Oj.dump({errors: ["Not Found"],  meta: meta}, status: 404, mode: :compat))
  end

  def unacceptable
    json_response(Oj.dump({errors: ["Unprocessable Entity"],  meta: meta}, status: 422, mode: :compat))
  end

  def internal_server_error
    json_response(Oj.dump({errors: ["Internal Server Error"],  meta: meta}, status: 500, mode: :compat))
  end
end
