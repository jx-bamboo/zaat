class OrderController < ApplicationController
  def new
    @order = Order.new
    @my_order_pendding = current_user.orders.my_order_pendding 
    p @my_order_pendding.size, '......'
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

  def text_to
    @order = Order.new
    render turbo_stream: turbo_stream.replace("text_to", partial: "order/text_to")
  end

  def picture_to
    @order = Order.new
    render turbo_stream: turbo_stream.replace("text_to", partial: "order/picture_to")
  end

  private 
  def order_params
    params.require(:order).permit(:prompt, :image, :model).merge(user_id: current_user.id)
  end
end
