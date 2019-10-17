class RemoveCheckGroupUniqueConstraint < ActiveRecord::Migration[5.2]
  def up
    remove_reference :check_groups, :disclosure_report
    add_reference :check_groups, :disclosure_report, type: :uuid, foreign_key: true, index: true
  end

  def down
    remove_reference :check_groups, :disclosure_report
    add_reference :check_groups, :disclosure_report, type: :uuid, foreign_key: true, index: { unique: true }
  end
end
