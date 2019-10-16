class CreateCheckGroup < ActiveRecord::Migration[5.2]
  def change
    create_table :check_groups, id: :uuid do |t|
      t.timestamps
    end

    add_reference :check_groups, :disclosure_report, type: :uuid, foreign_key: true, index: { unique: true }
  end
end
