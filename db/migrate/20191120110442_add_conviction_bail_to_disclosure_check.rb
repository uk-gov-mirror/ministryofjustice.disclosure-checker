class AddConvictionBailToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :conviction_bail, :string
  end
end
