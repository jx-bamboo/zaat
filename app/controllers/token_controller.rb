class TokenController < ApplicationController
  def index
    @total_token = current_user.token.balance
    @token_changes = current_user.token_changes.order(created_at: :desc)
  end
end