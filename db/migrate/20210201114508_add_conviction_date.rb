class AddConvictionDate < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :conviction_date, :date
    add_column :disclosure_checks, :approximate_conviction_date, :boolean, default: false
  end
end
