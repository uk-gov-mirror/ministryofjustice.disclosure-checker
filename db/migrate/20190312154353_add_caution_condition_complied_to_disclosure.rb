class AddCautionConditionCompliedToDisclosure < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :condition_complied, :string
  end
end
