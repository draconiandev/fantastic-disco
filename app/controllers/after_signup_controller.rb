# frozen_string_literal: true

class AfterSignupController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!

  steps :verify_mobile, :upload_docs

  def show
    case step
    when :verify_mobile
      skip_step if current_user.mobile_verified?
    when :upload_docs
      skip_step if current_user.docs_uploaded?
      @user_document = current_user.user_document.new
    end
    render_wizard
  end

  def update
    case step
    when :verify_mobile
      skip_step if current_user.mobile_verified?
      handle_mobile_verification
    end
    render_wizard current_user
  end

  private

  def otp_params
    params.require(:user).permit(:otp)
  end

  def handle_mobile_verification
    if valid_otp?
      current_user.update(mobile_verified: true)
    else
      redirect_to after_signup_path(:verify_mobile),
        error: "Entered OTP was wrong. Please try again!"       
    end
  end

  def valid_otp?
    # Redis.current.get(current_user.id)[:otp] == otp_params[:otp]
  end
end
