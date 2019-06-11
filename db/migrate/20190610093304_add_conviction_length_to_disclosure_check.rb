class AddConvictionLengthToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :conviction_length_type, :string
    add_column :disclosure_checks, :conviction_length, :integer
  end
end
