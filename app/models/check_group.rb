class CheckGroup < ApplicationRecord
  belongs_to :disclosure_report, default: -> { create_disclosure_report }
  has_many :disclosure_checks, dependent: :destroy
end
