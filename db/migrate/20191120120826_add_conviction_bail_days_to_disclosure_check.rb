class AddConvictionBailDaysToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :conviction_bail_days, :integer
  end
end
