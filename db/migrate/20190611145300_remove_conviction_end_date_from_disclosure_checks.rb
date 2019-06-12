class RemoveConvictionEndDateFromDisclosureChecks < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :conviction_end_date, :date
  end
end
