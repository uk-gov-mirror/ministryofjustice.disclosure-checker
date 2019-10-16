class CreateDisclosureReport < ActiveRecord::Migration[5.2]
  def change
    create_table :disclosure_reports, id: :uuid do |t|
      t.integer :status, default: 0
      t.timestamps
    end

    add_index :disclosure_reports, :status
  end
end
