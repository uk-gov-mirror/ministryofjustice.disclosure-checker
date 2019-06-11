class DisclosureCheck < ApplicationRecord
  enum status: {
    in_progress: 0,
    completed: 10,
  }
end
