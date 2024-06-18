module ApplicationHelper
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
end
