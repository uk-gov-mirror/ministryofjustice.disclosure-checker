class RemoveMotoringLifetimeBanFromDisclosureChecks < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :motoring_lifetime_ban, :string
  end
end
