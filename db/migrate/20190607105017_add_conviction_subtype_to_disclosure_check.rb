class AddConvictionSubtypeToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :conviction_subtype, :string
  end
end
