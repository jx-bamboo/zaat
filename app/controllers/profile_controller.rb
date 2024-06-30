class ProfileController < ApplicationController
  def index
    @total_token = current_user.token.balance
  end

  def my_model
    p '... my model ...'
    @order = Order.order(created_at: :desc)
  end
end
