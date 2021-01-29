class RemoveApproximateEndDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :approximate_motoring_disqualification_end_date, :boolean, default: false
  end
end
