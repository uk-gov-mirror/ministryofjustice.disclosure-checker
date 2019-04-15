class AddRehabilitationPreventionOrderToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :rehabilitation_prevention_order, :string
  end
end
