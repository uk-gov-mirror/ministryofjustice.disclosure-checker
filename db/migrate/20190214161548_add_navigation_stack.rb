class AddNavigationStack < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :navigation_stack, :string, array: true, default: []
  end
end
