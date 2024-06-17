class OrderController < ApplicationController
  def new
    @order = Order.new
  end
  
  def create
    p params, '..............'

    order = Order.new(order_params)
    p order, '....'
    if order.save
      p "ssssssssssss"
      redirect_to profile_my_model_path
    else
      p "eeeeeeeeeeeeeeeeeeeeee"
    end
  end

  def earn
    @order = Order.new
  end

  private 
  def order_params
    params.require(:order).permit(:prompt, :image, :model).merge(user_id: current_user.id)
  end
end
