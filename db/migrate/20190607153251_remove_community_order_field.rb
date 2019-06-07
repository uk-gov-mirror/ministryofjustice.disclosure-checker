class RemoveCommunityOrderField < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :community_order, :string
  end
end
