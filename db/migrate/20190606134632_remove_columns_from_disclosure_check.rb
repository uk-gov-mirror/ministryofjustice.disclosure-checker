class RemoveColumnsFromDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :caution_date, :string
    remove_column :disclosure_checks, :under_age_conviction, :string
    remove_column :disclosure_checks, :conviction_date, :string
  end
end
