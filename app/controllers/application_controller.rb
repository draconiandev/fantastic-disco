# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # For Rails 5, note that protect_from_forgery is no longer prepended to the before_action chain,
  # so if you have set authenticate_user before protect_from_forgery, your request will result in
  # "Can't verify CSRF token authenticity." To resolve this, either change the order in which you
  # call them, or use:
  protect_from_forgery prepend: true

  # Make sure that a user cannot go to any other route unless he/she has completed the registration.
  # But call this before action only if a user is signed in since we don't want this to happen to the
  # casural visitors of the website or any other scopes that we might add in the future.
  before_action :ensure_complete_registration, if: :user_signed_in?

  # Add a before action to permit extra attributes while signing up or updating the account
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    extra_keys = %i[username first_name last_name mobile_number email password password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_keys)
  end

  # Once a user signs up, he/she will be taken directly to the mobile verification page
  # Even if the user has completed the registration, after signup controller redirects
  # the user to the dashboard/root path.
  def after_sign_up_path_for(_user)
    after_signup_path(:verify_mobile)
  end

  # Similar to above method
  def after_sign_in_path_for(_user)
    after_signup_path(:verify_mobile)
  end

  def ensure_complete_registration
    redirect_to after_signup_path(:verify_mobile) unless completed_registration?
  end

  # Registration is complete when the user has verified the mobile number and uploaded
  # all the required documents
  def completed_registration?
    current_user.mobile_verified? && current_user.docs_uploaded?
  end
end
