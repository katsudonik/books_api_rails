class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordInvalid, with: :error422
  rescue_from ActiveRecord::RecordNotFound, with: :error404

  def error422(err)
    class_name = err.record.class.name.underscore
    active_model_errors = err.record.errors
    errors = []

    active_model_errors.details.each do |attribute, attribute_errors|
      attribute_errors.each do |error_info|
        error_key = error_info.delete(:error)
        message = active_model_errors.generate_message(
          attribute, error_key, error_info.except(*ActiveModel::Errors::CALLBACKS_OPTIONS),
        )
        errors <<
          {
            message: active_model_errors.full_message(attribute, message)
          }
      end
    end

    render json: { errors: errors }, status: :unprocessable_entity
  end  

  def error404(err)
    render json: { errors: "resource not found" }, status: 404
  end

end
