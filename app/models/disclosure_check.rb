class DisclosureCheck < ApplicationRecord
  belongs_to :check_group, default: -> { create_check_group }
  has_one :disclosure_report, through: :check_group

  enum status: {
    in_progress: 0,
    completed: 10,
  }

  def relevant_order?
    # conviction subtype will be nil if it's a caution
    return false if conviction_subtype.nil?

    ConvictionType.find_constant(conviction_subtype).relevant_order?
  end
end
