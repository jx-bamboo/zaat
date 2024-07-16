class OrderController < ApplicationController
  before_action :custom_authenticate_user!
  def show
    @order = Order.find(params[:id])
    render turbo_stream: turbo_stream.replace("model_show", partial: "order/show", locals: {order: @order})
  end

  def new
    @order = Order.new
    @not_success = current_user.orders.not_success
  end
  
  def create
    order = Order.new(order_params)
    if order.save
      OrderJob.perform_later(order.id)
      redirect_to profile_my_model_path, notice: "Success"
    else
      redirect_to new_order_path, notice: "Failed"
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
    params.require(:order).permit(:prompt, :image, :model, :txhash).merge(user_id: current_user.id)
  end
end
