class AddKnownConvictionDateToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :known_conviction_date, :string
  end
end
