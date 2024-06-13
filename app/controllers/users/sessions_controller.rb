# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    # super
    if user_signed_in?
      p "signed_in"
      render turbo_stream: turbo_stream.replace("header_right_button", partial: "layouts/signed_button") and return false
    else
      p "not signed_in"
      render turbo_stream: turbo_stream.replace("errors", partial: "users/shared/msg") and return false
    end

  end

  # DELETE /resource/sign_out
  def destroy
    # super
    sign_out
    # render turbo_stream: turbo_stream.replace("header_right_button", partial: "layouts/no_signed_button")
    render turbo_stream: turbo_stream.replace("header_right_button", partial: "layouts/no_signed_button")
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:address])
  # end
end
