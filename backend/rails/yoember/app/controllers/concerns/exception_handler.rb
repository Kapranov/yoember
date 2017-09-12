module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response(Oj.dump({ message: e.message, meta: meta }, :not_found, mode: :compat))
    end
  end

  private

  def four_twenty_two(e)
    json_response(Oj.dump({ message: e.message, meta: meta }, :unprocessable_entity, mode: :compat))
  end
end
