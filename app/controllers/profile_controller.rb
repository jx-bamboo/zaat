class ProfileController < ApplicationController
  before_action :custom_authenticate_user!
  def index
    @total_token = current_user.token&.balance
  end

  def my_model
    @pagy, @order = pagy(Order.order(created_at: :desc), items: 20, anchor_string: 'data-remote="false"')
  end

  def verify_invite_code
    if request.post?
      user = User.find_by(invitation_code: params[:code])

      if user
        begin
          user.transaction do
            user.invited_users.create(my_user_id: current_user.id)
    
            if user.token.nil?
              token = user.create_token(balance: 5000)
            else
              token = user.token.increment(:balance, 5000)
            end
    
            user.token_changes.create(amount: 5000, event: 'Invite user', token_id: token.id)
          end

          if current_user.token.nil?
            token = current_user.create_token(balance: 1000)
          else
            token = current_user.token.increment(:balance, 1000)
          end
          current_user.token_changes.create(amount: 1000, event: 'Add invite code', token_id: token.id)
        rescue
          flash[:notice] = "user is invalid"
        end
        render turbo_stream: turbo_stream.replace("verify", partial: "profile/verify")
        return
      else
        flash[:notice] = "Invitation code is invalid"
      end
    end
  end

  def verify_email
    if request.post?
      email = params[:email]
      user = User.find_by(email:)
      if user
        flash[:notice] = "Email is invalid."
      else
        current_user.update(email:, confirmed_at: nil)
        flash[:notice] = "Email is updated. You can confirm your email address by going to the mailbox."
        render turbo_stream: turbo_stream.replace("verify", partial: "profile/verify")
        return
      end
    end
  end
end
