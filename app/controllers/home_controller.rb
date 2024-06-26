class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token
  def test
    p params, '...'
    p request.headers, '|'
    render plain: "ok"
    
  end
  def auth_modal
    # respond_to do |format|
    #   format.turbo_stream { render turbo_stream: turbo_stream.replace('user_sign', partial: 'layouts/auth_modal') }
    #   format.all { render plain: "Unsupported Format", status: :unsupported_media_type }
    # end
    render turbo_stream: turbo_stream.replace('user_sign', partial: 'layouts/auth_modal')
  end
end
