class AddKnownDateToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :known_date, :date
  end
end
