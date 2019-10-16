class DisclosureReport < ApplicationRecord
  has_many :check_groups, dependent: :destroy

  enum status: {
    in_progress: 0,
    completed: 10,
  }

  def self.purge!(date)
    where('created_at <= :date', date: date).destroy_all
  end
end
