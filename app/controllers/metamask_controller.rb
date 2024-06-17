class MetamaskController < ApplicationController
  protect_from_forgery with: :null_session

  def eth
    address = params[:address]
    if user_signed_in?
      u = User.find_by(address:)
      if u.nil?
        if current_user.update(address:)
          render json: {data: "reload"} and return
        else
          render json: {data: current_user.errors.full_messages} and return
        end
      else
        render json: {data: "Address is Invalid."}
      end
    else
      user = User.find_by_address(address)
      if user
        sign_in(user)
        render json: {data: "reload"}
      else
        user = User.new(email: rand_email, password: "123456", address:, confirmed_at: Time.now)
        respond_to do |format|
          if user.save
            sign_in(user)
            render json: {data: "reload"} and return
          else
            render json: {data: user.errors} and return
          end
        end
      end

    end

  end

  def index
    render 'index'
  end

  # def sign_in
  #   p '... sign in ... '
  #   message = Siwe::Message.from_json_string session[:message]

  #   if message.verify(params.require(:signature), message.domain, message.issued_at, message.nonce)
  #     session[:message] = nil
  #     session[:ens] = params[:ens]
  #     session[:address] = message.address

  #     nonce = DateTime.now
  #     if current_user
  #       User.upsert({ address: message.address, nonce: nonce })
  #     else
  #       p rand_email, '......'
  #       User.upsert({ email: rand_email, address: message.address, nonce: nonce })
  #     end

  #     render json: { ens: session[:ens], address: session[:address], lastSeen: nonce }
  #   else
  #     head :bad_request
  #   end
  # end

  def profile
    p "... profile ..."
    if current_user
      p " .. current_user .."
      current_user.seen
      current_user.save
      render json: { ens: session[:ens], address: session[:address], lastSeen: current_user.nonce }
    else
      p " .. not current_user .."
      head :no_content
    end
  end

  def message
    p "... message ..."
    nonce = Siwe::Util.generate_nonce
    message = Siwe::Message.new(
      request.host_with_port,
      params[:address],
      "#{request.protocol}#{request.host_with_port}",
      '1',
      {
        statement: 'Metamask login and registration in zaat',
        nonce: nonce,
        chain_id: params[:chainId]
      }
    )

    session[:message] = message.to_json_string

    render plain: message.prepare_message
  end

  def sign_out
    p "... sign out ..."
    if current_user
      current_user.seen
      current_user.save
      session[:ens] = nil
      session[:address] = nil
      head :no_content
    else
      head :unauthorized
    end
  end

  private

  def rand_email
  username_length = rand(6..11)  
  username = ('a'..'z').to_a.shuffle[0...username_length].join
  domain = "address.zaat"
  "#{username}@#{domain}"  
  end
end
