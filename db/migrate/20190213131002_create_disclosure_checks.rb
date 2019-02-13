class CreateDisclosureChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :disclosure_checks, id: :uuid do |t|
      t.timestamps
    end
  end
end
