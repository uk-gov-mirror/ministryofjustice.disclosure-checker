class RemoveMotoringDisqualificationEndDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :motoring_disqualification_end_date, :date
  end
end
