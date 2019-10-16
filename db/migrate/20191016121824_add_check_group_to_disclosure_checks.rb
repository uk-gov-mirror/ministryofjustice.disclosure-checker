class AddCheckGroupToDisclosureChecks < ActiveRecord::Migration[5.2]
  def change
    add_reference :disclosure_checks, :check_group, type: :uuid, foreign_key: true, index: true
  end
end
