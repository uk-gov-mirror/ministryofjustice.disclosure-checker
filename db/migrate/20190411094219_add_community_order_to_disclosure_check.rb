class AddCommunityOrderToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :community_order, :string
  end
end
