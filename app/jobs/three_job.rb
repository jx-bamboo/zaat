class ThreeJob < ApplicationJob
  queue_as :three_model

  API_Key = "tsk_ar0lW2-VK1Njosnh0dnYpbfb3NlvudczL8elxuh8DZE"
  URI = "http://120.224.26.32:11483"

  def perform(id)
    logger.info '... into three job ...'

    order = Order.find_by(id:)
    return false unless order && order.status == "success_one"
    
    data = build_api_data(order)
    response_body = call_three_api(data, id)

    begin
      if response_body
        logger.info "... deal result ..."
        order.update(status: 2)
        # ==== 处理返回的结果 start ====

        ## 保存文件到public/order
        FileUtils.mkdir_p("public/order") unless File.directory?("public/order")
        File.open(Rails.root.join("public", "order", "order_#{order.id}.tar.gz"), 'wb') do |f|
          tar_file = Base64.decode64(response_body)
          f.write(tar_file)
        end

        ## 解压文件
        Dir.chdir(Rails.root.join("public", "order")) do
          system("tar -xzf order_#{order.id}.tar.gz")
        end

        ## 删除原文件
        FileUtils.rm(Rails.root.join("public", "order", "order_#{order.id}.tar.gz"))

        ## 列出原文件
        files_path = Dir.glob(Rails.root.join("public/order/order_#{order.id}", "*"))
        logger.info "files_path: #{files_path}"

        # ==== 处理返回的结果 end ====
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
    
    conn = Faraday.new(url: URI) do |faraday|
      faraday.request :json
      faraday.headers['Content-type'] = 'application/json'
      faraday.headers['Accept-Encoding'] = 'identity'
      faraday.headers.delete('User-Agent')
      faraday.options[:timeout] = 1000
      faraday.options[:open_timeout] = 5
    end
    response = conn.post('/', data)
    response_body = response.body.force_encoding('UTF-8')
    
    begin
      raise "API response error: #{result['message']}" unless response_body
      response_body
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
    content.first.merge(taskId: "order_#{order.id}", API_Key:)
  end

  def print_keys(hash, prefix = '')
    hash.each_key do |key|
      puts "#{prefix}#{key}"
      if hash[key].is_a?(Hash)
        print_keys(hash[key], "#{prefix}#{key}.")
      end
    end
  end

  def save_tar(id, res_body)
    p '... into save ...'
    File.open(Rails.root.join("public", "order", "image_#{id}.tar.gz"), "w") do |file|
      file.write(res_body)
    end
  end

end
