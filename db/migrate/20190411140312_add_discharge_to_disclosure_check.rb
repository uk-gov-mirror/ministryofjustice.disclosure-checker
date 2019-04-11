class AddDischargeToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :discharge, :string
  end
end
