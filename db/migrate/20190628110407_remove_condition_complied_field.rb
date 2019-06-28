class RemoveConditionCompliedField < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :condition_complied, :string
  end
end
