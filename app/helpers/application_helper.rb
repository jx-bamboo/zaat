module ApplicationHelper
  def simple_address(addr)
    return false unless addr.present?
    return addr[0, 4] + "..." + addr[-4..-1]
  end
end
