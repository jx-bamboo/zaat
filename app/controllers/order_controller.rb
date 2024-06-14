class OrderController < ApplicationController
  def new
    @order = Order.new
  end
  
  def create
    
  end

  def earn
    @order = Order.new
  end
end
