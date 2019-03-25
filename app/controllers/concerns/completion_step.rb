# The step including this concern will mark the record as `completed`.
# Some operations can't be done or differ on `completed` records as
# opposite to records with status `in_progress`.
#
module CompletionStep
  extend ActiveSupport::Concern

  included do
    before_action :mark_completed, unless: :completed?
  end

  private

  def completed?
    current_disclosure_check.completed?
  end

  def mark_completed
    current_disclosure_check.completed!
  end
end
