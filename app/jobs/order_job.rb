class OrderJob < ApplicationJob
  queue_as :metamask_pay

  def perform(id, txhash, status)
    return false unless status == "pending"

    order = Order.find_by(id:)
    return false unless order

    begin
      if call_bsc_api(txhash)
        order.update(status: 1)
        add_token(id)
        ThreeJob.perform_later(order.id)
      else
        raise 'API returned unsuccessful or unexpected data.'
      end
    rescue StandardError => e
      logger.error "OrderJob error: #{e.message}, order_id: #{id}, txhash: #{txhash}"
      raise e
    end
  end

  private

  def call_bsc_api(txhash)
    bsc_key = "1M5JQRT1W4B4DYBBKTPYD1WMMHGIU9T8G9"
    uri = "https://api-testnet.bscscan.com/api?module=account&action=txlistinternal&txhash=#{txhash}&apikey=#{bsc_key}"
    response = Faraday.get(uri)
    
    begin
      raise "HTTP request failed: #{JSON.parse(response.body)['message']}" unless response.status >= 200 && response.status < 300
      
      result = JSON.parse(response.body)
      raise "API response error: #{result['message']}" unless result["status"] == "1"
      
      return true
    rescue JSON::ParserError => e
      logger.error "JSON error: #{e.message}"
      return false
    rescue StandardError => e
      logger.error "API call error: #{e.message}"
      return false
    end
  end

  def add_token(u_id)
    user = User.find_by(id: u_id)
    user.transaction do
      if user.token.nil?
        token = user.create_token(balance: 1000)
      else
        token = user.token.increment(:balance, 1000)
      end
      user.token_changes.create(amount: 1000, event: 'metamask pay', token_id: token.id)
    end
  end

end
