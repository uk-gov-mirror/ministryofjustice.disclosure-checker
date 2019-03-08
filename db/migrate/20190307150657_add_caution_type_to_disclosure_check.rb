class AddCautionTypeToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :caution_type, :string
  end
end
