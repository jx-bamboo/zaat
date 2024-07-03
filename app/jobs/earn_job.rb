class EarnJob < ApplicationJob
  queue_as :earn_pay

  def perform(*args)
    # Do something later
    return false unless status == 0

    draft = Draft.find_by(id:)
    return false unless draft

  end
end
