class AddFinancialToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :financial, :string
  end
end
