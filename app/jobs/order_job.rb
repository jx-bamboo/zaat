class OrderJob < ApplicationJob
  queue_as :default

  def perform(id, txhash, status)
    p params, '....................'
    return false if status != 0

    order = Order.find(order_id)
    bsc_result = call_bsc_api(txhash)

    if bsc_result
      order.update(status: 1)
      ThreeJob.perform_later(order.id)
    end
  end

  private

  def call_bsc_api(txhash)
    bsc_key = "1M5JQRT1W4B4DYBBKTPYD1WMMHGIU9T8G9"
    url = URI("https://api-testnet.bscscan.com/api?module=account&action=txlistinternal&txhash=#{txhash}&apikey=#{bsc_key}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    
    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      if result["status"] == "1"
        # 处理结果
        # balance = result["result"].to_i / 10**18  # 将余额转换成BSC单位
        return true
      else
        # 如果API响应不是成功状态，则记录错误或者抛出异常
        puts "API返回错误：#{result["message"]}"
        # raise "API返回错误：#{result["message"]}"
        return false
      end
    else
      # 处理HTTP请求失败的情况
      puts "HTTP请求失败：#{response.code} #{response.message}"
      # raise "HTTP请求失败：#{response.code} #{response.message}"
      return false
    end
  end
end
