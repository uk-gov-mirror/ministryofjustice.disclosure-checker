class AddKnownCautionDateToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :known_caution_date, :string
  end
end
