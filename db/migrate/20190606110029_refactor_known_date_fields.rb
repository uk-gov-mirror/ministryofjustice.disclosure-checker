class RefactorKnownDateFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :disclosure_checks, :known_caution_date, :is_date_known
    remove_column :disclosure_checks, :known_conviction_date, :string
  end
end
