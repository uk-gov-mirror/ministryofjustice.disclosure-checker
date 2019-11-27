class AddUnknownDateFields < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :approximate_known_date, :boolean, default: false
    add_column :disclosure_checks, :approximate_conditional_end_date, :boolean, default: false
    add_column :disclosure_checks, :approximate_compensation_payment_date, :boolean, default: false
    add_column :disclosure_checks, :approximate_motoring_disqualification_end_date, :boolean, default: false
  end
end
