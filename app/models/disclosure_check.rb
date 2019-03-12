class DisclosureCheck < ApplicationRecord
  enum status: {
    in_progress: 0,
    completed: 10,
  }

  def caution?
    kind == 'caution'
  end

  def conditional_caution_type?
    caution_type&.include? 'conditional'
  end
end
