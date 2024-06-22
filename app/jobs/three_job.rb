class ThreeJob < ApplicationJob
  queue_as :three_model

  def perform(id)
    logger.info '... into three job ...'
    order = Order.find(id)
    return false unless order && order.status == 1
    
    content = [order.prompt, order.image].compact.first
    return false if content.blank?

    three_result = call_three_api(order.id, content, order.status)

    if three_result
      order.update(status: 2)
      # save file to 
    end
  end
  
  private

  def call_three_api(id, content, status)
    api_key = "tsk_ar0lW2-VK1Njosnh0dnYpbfb3NlvudczL8elxuh8DZE"
    uri = "http://120.224.26.32:11489/api?id=#{id}&content=#{content}&status=#{status}&api_key=#{api_key}"

    begin
      response = Faraday.get(uri)
      result = JSON.parse(response.body)
      raise "API response error: #{result['message']}" unless result["status"] == "1"
      true
    rescue JSON::ParserError => e
      logger.error "JSON error: #{e.message}"
      false
    rescue StandardError => e
      logger.error "API call error: #{e.message}"
      false
    end

  end
end
