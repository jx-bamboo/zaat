class HomeController < ApplicationController
  def auth_modal
    # respond_to do |format|
    #   format.turbo_stream { render turbo_stream: turbo_stream.replace('user_sign', partial: 'layouts/auth_modal') }
    #   format.all { render plain: "Unsupported Format", status: :unsupported_media_type }
    # end
    render turbo_stream: turbo_stream.replace('user_sign', partial: 'layouts/auth_modal')
  end
end
