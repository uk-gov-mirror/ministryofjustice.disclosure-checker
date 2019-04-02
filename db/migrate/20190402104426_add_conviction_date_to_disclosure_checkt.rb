class AddConvictionDateToDisclosureCheckt < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :conviction_date, :date
  end
end
