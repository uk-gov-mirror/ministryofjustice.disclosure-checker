class AddCompletedAtToDisclosureReports < ActiveRecord::Migration[6.1]
  def change
    add_column :disclosure_reports, :completed_at, :datetime
  end
end
