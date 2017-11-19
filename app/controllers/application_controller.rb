# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # For Rails 5, note that protect_from_forgery is no longer prepended to the before_action chain,
  # so if you have set authenticate_user before protect_from_forgery, your request will result in
  # "Can't verify CSRF token authenticity." To resolve this, either change the order in which you
  # call them, or use:
  protect_from_forgery prepend: true

  # Add a before action to permit extra attributes while signing up or updating the account
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    extra_keys = %i[username first_name last_name mobile_number email password password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_keys)
  end
end
