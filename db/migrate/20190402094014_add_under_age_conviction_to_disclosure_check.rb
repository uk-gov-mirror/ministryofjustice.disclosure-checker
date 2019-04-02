class AddUnderAgeConvictionToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :under_age_conviction, :string
  end
end
