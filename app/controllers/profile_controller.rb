class ProfileController < ApplicationController
  def index
  end

  def my_model
    p '... my model ...'
    @order = Order.all
  end
end
