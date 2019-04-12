class AddMotoringToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :motoring, :string
  end
end
