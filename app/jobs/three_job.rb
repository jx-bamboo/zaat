class ThreeJob < ApplicationJob
  queue_as :default

  def perform(id)
    order = Order.find(id)
    return false if order.status != 1
    content = order.prompt if order.prompt.present?
    content = order.image if order.image.attached?
    three_result = call_three_api(order.id, content, order.status)

    if three_result
    end
  end
  
  private

  def call_3d_api(data)
    # 调用3d.com的API的逻辑
    # 使用HTTParty或其他HTTP请求库
  end
end
