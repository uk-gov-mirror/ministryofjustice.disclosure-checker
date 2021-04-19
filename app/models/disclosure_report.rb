class DisclosureReport < ApplicationRecord
  has_many :check_groups, dependent: :destroy
  has_many :disclosure_checks, through: :check_groups, source: :disclosure_checks

  enum status: {
    in_progress: 0,
    completed: 10,
  }

  def self.purge!(date)
    where('created_at <= :date', date: date).destroy_all
  end

  def completed!
    update!(status: :completed, completed_at: Time.current)
  end
end
