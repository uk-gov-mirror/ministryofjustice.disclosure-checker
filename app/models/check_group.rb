class CheckGroup < ApplicationRecord
  belongs_to :disclosure_report, default: -> { create_disclosure_report }
  has_many :disclosure_checks, dependent: :destroy

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }
end
