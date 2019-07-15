class DisclosureCheck < ApplicationRecord
  enum status: {
    in_progress: 0,
    completed: 10,
  }

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }

  def self.purge!(date)
    where('created_at <= :date', date: date).destroy_all
  end
end
