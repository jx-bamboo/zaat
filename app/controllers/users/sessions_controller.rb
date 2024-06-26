# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    # render turbo_stream: turbo_stream.replace("errors", partial: "users/shared/unconfirmed") and return if user && user.unconfirmed_email.nil?

    if user && user.valid_password?(params[:user][:password])
      sign_in(user)
      # render turbo_stream: turbo_stream.replace("header_right_button", partial: "layouts/signed_button")
      render turbo_stream: [
        turbo_stream.replace("header_right_button", partial: "layouts/signed_button"),
        turbo_stream.replace("two_btn", partial: "home/two_btn")
      ]
    else
      render turbo_stream: turbo_stream.replace("errors", partial: "users/shared/msg")
    end


    # super
    # if user_signed_in?
    #   p "---- signed_in ----"
    #   render turbo_stream: turbo_stream.replace("header_right_button", partial: "layouts/signed_button")
    #   return
    # else
    #   p "---- not signed_in ----"
    #   render turbo_stream: turbo_stream.replace("errors", partial: "users/shared/msg")
    #   return
    # end

  end

  # DELETE /resource/sign_out
  def destroy
    # super
    sign_out
    # render turbo_stream: turbo_stream.replace("header_right_button", partial: "layouts/no_signed_button")
    redirect_to root_path
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:address])
  # end
end
