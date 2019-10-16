class DisclosureCheck < ApplicationRecord
  belongs_to :check_group, default: -> { create_check_group }

  enum status: {
    in_progress: 0,
    completed: 10,
  }

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }

  # TODO: once the new data models are in place, we would do the purge
  # through the DisclosureReport model, instead of here, and we will be
  # able to remove this method and spec.
  #
  def self.purge!(date)
    where('created_at <= :date', date: date).destroy_all
  end
end
