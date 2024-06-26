class ThreeJob < ApplicationJob
  queue_as :three_model

  API_Key = "tsk_ar0lW2-VK1Njosnh0dnYpbfb3NlvudczL8elxuh8DZE"

  def perform(id)
    logger.info '... into three job ...'

    order = Order.find_by(id:)
    return false unless order && order.status == "success_one"
    
    data = build_api_data(order)
    # {:name=>"SubmitDraftModelGenerationTask", :prompt=>"aaa", :taskId=>27, :API_Key=>"tsk_ar0lW2-VK1Njosnh0dnYpbfb3NlvudczL8elxuh8DZE"}
    three_result = call_three_api(data)

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

  def call_three_api(data)
    p ".............in to call three api.................."
    p data, '|'
    # uri = "http://120.224.26.32:47107"

    # uri = "http://120.224.26.32:52313"
    uri = "http://120.224.26.32:13465"
    # conn = Faraday.new(
    #   url: uri, 
    #   params: data, 
    #   headers: {
    #     'Content-type' => 'application/json', 
    #     'Content-length' => data.to_json.length.to_s,
    #     'Accept-Encoding' => 'identity'
    #   },
    #   request: {timeout: 1000, open_timeout: 5}
    # )
    # p conn, '================'

    # response = conn.post()

    # uri = "http://localhost:3000"
    conn = Faraday.new(url: uri) do |faraday|
      faraday.request :json
      faraday.headers['Content-type'] = 'application/json'
      faraday.headers['Accept-Encoding'] = 'identity'
      faraday.headers.delete('User-Agent')
      faraday.options[:timeout] = 1000
      faraday.options[:open_timeout] = 5
    end

    p conn, '==============='

    response = conn.post('/', data) # 将"data"作为请求体发送

    p response.status, response.body,'==============='

    # host = '120.224.26.32'
    # port = 52313
    # uri = URI("http://#{host}:#{port}/")
    # req = Net::HTTP::Post.new(uri.path)
    # req.content_type = 'application/json'
    # req.content_length = data.to_json.length
    # req.body = data.to_json
    
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.open_timeout = 1000
    # http.read_timeout = 1000
    # p http, '...'
    # result = http.request(req)
    # p result.body, '..........................'
    

    begin
      raise "HTTP request failed: #{JSON.parse(response.body)['message']}" unless response.status >= 200 && response.status < 300
      result = JSON.parse(response.body)
      logger.info ".......... #{result} ............"

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
    content << {name: "imgtask", image: order.image} if order.image.attached?
    content.first.merge(taskId: "image_#{order.id}", API_Key:)
  end
end
