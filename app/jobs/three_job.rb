class ThreeJob < ApplicationJob
  queue_as :three_model

  API_Key = "tsk_ar0lW2-VK1Njosnh0dnYpbfb3NlvudczL8elxuh8DZE"

  def perform(id)
    logger.info '... into three job ...'

    order = Order.find_by(id:)
    return false unless order && order.status == "success_one"
    
    data = build_api_data(order)
    # {:name=>"SubmitDraftModelGenerationTask", :prompt=>"aaa", :taskId=>27, :API_Key=>"tsk_ar0lW2-VK1Njosnh0dnYpbfb3NlvudczL8elxuh8DZE"}
    three_result = call_three_api(data, id)

    begin
      if three_result
        logger.info "... deal result ..."
        order.update(status: 2)
        # 处理返回的结果
      else
        raise 'API returned unsuccessful or unexpected data.'
      end
    rescue StandardError => e
      logger.error "ThreeJob error: #{e.message}, order_id: #{id}"
      raise e
    end
    
  end
  
  private

  def call_three_api(data, id)
    p ".............in to call three api.................."
    
    uri = "http://120.224.26.32:11483"
    conn = Faraday.new(url: uri) do |faraday|
      faraday.request :json
      faraday.headers['Content-type'] = 'application/json'
      faraday.headers['Accept-Encoding'] = 'identity'
      faraday.headers.delete('User-Agent')
      faraday.options[:timeout] = 1000
      faraday.options[:open_timeout] = 5
    end
    response = conn.post('/', data)
    
    begin
    p response.status, '==============='
      # raise "HTTP request failed: #{JSON.parse(response.body)['message']}" unless response.status >= 200 && response.status < 300
      result = JSON.parse(response.body)
      logger.info ".......... into begin ............"
      logger.info "==== #{print_keys(result)} ===="

      save_tar(id, result)

      return false

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

  def build_api_data(order)
    logger.info "... in to build api data..."
    content = []
    content << {name: "SubmitDraftModelGenerationTask", prompt: order.prompt} if order.prompt.present?
    if order.image.attached?
      base64_data = Base64.encode64(order.image.blob.download)
      content << {name: "imgtask", image: base64_data}
    end
    content.first.merge(taskId: "image_#{order.id}", API_Key:)
  end

  def print_keys(hash, prefix = '')
    hash.each_key do |key|
      puts "#{prefix}#{key}"
      if hash[key].is_a?(Hash)
        print_keys(hash[key], "#{prefix}#{key}.")
      end
    end
  end

  def save_tar(id, response)
    p '... into save ...'
    File.open(Rails.root.join("public", "order", "image_#{id}.tar.gz"), "w") do |file|
      file.write(response.body)
    end
  end

end
