class ProfileController < ApplicationController
  def index
  end

  def my_model
    p '... my model ...'
    @order = Order.order(created_at: :desc)
  end
end
