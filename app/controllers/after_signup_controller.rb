# frozen_string_literal: true

class AfterSignupController < ApplicationController
  include Wicked::Wizard
  skip_before_action :ensure_complete_registration
  before_action :authenticate_user!

  # Define the steps for the wizard
  steps :verify_mobile, :enter_address, :upload_docs

  # Use a switch statement to determine what to do when a user is on a particular step
  # :verify_mobile gets the current otp using the safe operator rather than failing
  # since it doesn't affect our boolean checking
  def show
    case step
    when :verify_mobile
      skip_step if current_user.mobile_verified?
      # TODO: Remove this once SMS provider has been added
      @otp = Redis.current&.get(current_user.id)
    when :enter_address
      skip_step if current_user.address_entered?
      @address = Address.find_or_initialize_by(user: current_user, address_type: :permanent)
    when :upload_docs
      skip_step if current_user.docs_uploaded?
      @user_document = UserDocument.find_or_initialize_by(user: current_user)
    end
    render_wizard
  end

  def update
    case step
    when :verify_mobile
      skip_step if current_user.mobile_verified?
      handle_mobile_verification
    when :enter_address
      skip_step if current_user.address_entered?
      handle_address_input
    when :upload_docs
      skip_step if current_user.docs_uploaded?
      handle_docs_upload
    end
  end

  private

  # If it is a valid otp, update the user object and clean up the redis db.
  # Else, redirect the same page with the error message
  def handle_mobile_verification
    if valid_otp?
      current_user.update(mobile_verified: true)
      Redis.current.del(current_user.id)
      # I18n.t 'devise.sessions.signed_in'
      flash[:success] = I18n.t 'after_signup.verification_success'
      render_wizard current_user
    else
      flash[:error] = I18n.t 'after_signup.verification_failure'
      render after_signup_path(:verify_mobile)
    end
    # current_user.update(mobile_verified: true) if valid_otp?
  end

  # This can be made more secure by checking again here that the user has not changed the mobile number
  def valid_otp?
    Redis.current.get(current_user.id) == otp_params[:otp]
  end

  def otp_params
    params.require(:user).permit(:otp)
  end

  def handle_address_input
    @address = current_user.build_permanent_address(address_params)
    if @address.save
      flash[:success] = I18n.t 'after_signup.address_success'
      render_wizard current_user
    else
      flash[:error] = I18n.t 'after_signup.address_failure'
      render after_signup_path(:enter_address)
    end
  end

  def address_params
    params.require(:address).permit(:address_line_1, :address_line_2, :city, :state, :country, :pincode)
          .merge(address_type: :permanent)
  end

  # This method follows the same logic as handling the mobile verification
  # Build a user document for user, and save it.
  # If it saves, render the wizard which takes the user to finish_wizard_path
  # Else, the same page will be rendered with the errors
  def handle_docs_upload
    @user_document = current_user.build_user_document(document_params)
    if @user_document.save
      flash[:success] = I18n.t 'after_signup.upload_success'
      render_wizard current_user
    else
      flash[:error] = I18n.t 'after_signup.upload_failure'
      render after_signup_path(:upload_docs)
    end
  end

  def document_params
    params.require(:user_document).permit(:pan_number, :pan, :aadhar_number, :aadhar, :passport_number, :passport)
  end
end
