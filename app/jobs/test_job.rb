class TestJob < ApplicationJob
  queue_as :default

  API_Key = Rails.application.credentials.dig(:gpt_api_key)
  URI = "http://120.224.26.32:11483"

  def perform(id)
    logger.info '... into test job ...'

    order = Order.find_by(id:)
    logger.info "... #{order.id} ..."
    return false unless order && order.status == "creating"
    
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
        # Dir.chdir(Rails.root.join("public", "order")) do
        #   system("tar -xzf order_#{order.id}.tar.gz")
        # end

        target_dir = Rails.root.join("public", "order")
        archive_path = target_dir.join("order_#{order.id}.tar.gz")
        # 检查并可能地重命名解压出的目录
        Dir.chdir(target_dir.join('tmp')) do
          entries = Dir.entries('.')
          # 过滤出目录（排除'.'和'..'）
          directories = entries.select { |entry| File.directory?(entry) && entry != '.' && entry != '..' }
          
          # 假设解压出的目录只有一个，且我们想要重命名它
          if directories.length == 1
            extracted_dir = directories.first
            # 检查解压出的目录名是否已经是正确的格式
            if !extracted_dir.match?(/^order_#{order.id}$/)
              # 如果不是，则重命名它
              new_dir_name = "order_#{order.id}"
              FileUtils.mv(extracted_dir, new_dir_name)
            end
            
            # 如果需要，将重命名后的目录移出tmp子目录到目标位置
            FileUtils.mv(new_dir_name, "../#{new_dir_name}") unless new_dir_name == extracted_dir
            
            # 清理tmp子目录（如果它是空的）
            FileUtils.rmdir('tmp') if Dir.empty?('tmp')
          end
        end

        ## 删除原文件
        FileUtils.rm(Rails.root.join("public", "order", "order_#{order.id}.tar.gz"))

        ## 列出原文件
        files_path = Dir.glob(Rails.root.join("public/order/order_#{order.id}", "*"))
        logger.info "files_path: #{files_path}"
        logger.info "---- success ----"

        # ## 移动文件到指定目录
        # Dir.glob(Rails.root.join("public/order/order_#{order.id}", "*")).each do |file|
        #   FileUtils.mv(file, Rails.root.join("public/order/#{order.id}", File.basename(file)))
        # end

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
    p ".............response_body: #{id}........"
    
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
    content << {name: "test", prompt: order.prompt} if order.prompt.present?
    if order.image.attached?
      base64_data = Base64.encode64(order.image.blob.download)
      content << {name: "test", image: base64_data}
    end
    content.first.merge(taskId: "order_#{order.id}", API_Key:)
  end
end
