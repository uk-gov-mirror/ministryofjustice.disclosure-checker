class RemoveIsDateKnownField < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :is_date_known, :string
  end
end
