class AddCautionConditionalEndDateToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :conditional_end_date, :date
  end
end
