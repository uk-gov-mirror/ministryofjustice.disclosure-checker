class AddConvictionTypeToDisclosureCheckt < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :conviction_type, :string
  end
end
