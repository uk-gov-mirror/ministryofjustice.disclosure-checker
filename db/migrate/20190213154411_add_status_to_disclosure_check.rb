class AddStatusToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :status, :integer, default: 0
    add_index  :disclosure_checks, :status
  end
end
