# The step including this concern will mark the record as `completed`.
# Some operations can't be done or differ on `completed` records as
# opposite to records with status `in_progress`.
#
module CompletionStep
  extend ActiveSupport::Concern

  included do
    before_action :mark_report_completed, unless: :report_completed?
  end

  private

  def report_completed?
    current_disclosure_report.completed?
  end

  def mark_report_completed
    current_disclosure_report.completed!
  end
end
