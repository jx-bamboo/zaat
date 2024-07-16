module ApplicationHelper
  include Pagy::Frontend
  def simple_address(addr)
    return false unless addr.present?
    return addr[0, 4] + "..." + addr[-4..-1]
  end

  def display_percentage_progress(created_at)
    time_diff = (Time.current-created_at).to_i
    if time_diff < 6000
      percentage = [(time_diff / 6000.0) * 100, 0].max
      
      content_tag(:div, class: "progress border-0", role: "progressbar", aria: {label: "example", valuenow: percentage, valuemin: "0", valuemax: "100"}) do
        content_tag(:div, nil, class: "progress-bar border-1", style: "width: #{percentage}%;background-image: var(--main-bg-gradient) !important;")
      end
    end
  end

  def order_percentage_progress(status)
    p status, '..............................'
    value = status == "pending" ? 33.33 : 66.66
    # value = [33.33, 66.66][status.to_i]
    content_tag(:div, class: "progress border-0", role: "progressbar", aria: {label: "example", valuenow: value, valuemin: "0", valuemax: "100"}) do
      content_tag(:div, nil, class: "progress-bar border-1", style: "width: #{value}%;background-image: var(--main-bg-gradient) !important;")
    end
  end

  def is_image_content_type?(content_type)
    content_type =~ %r{^(image/(?:jpeg|pjpeg|png|gif|tiff|bmp|heif|webp|avif|svg\+xml))$}
  end  

  def is_verified_user(my_user_id)
    invited = InvitedUser.find_by(my_user_id:)
    invited ? true : false
  end

  def is_verified_email(current_user)
    email = current_user.email

    if email.present? && email.end_with?("@address.zaat") && current_user.confirmed_at.present?
      return false
    elsif email.present? && current_user.confirmed_at.nil?
      return false
    end
  end
end
