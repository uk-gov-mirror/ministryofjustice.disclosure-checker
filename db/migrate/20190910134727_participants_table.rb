class ParticipantsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :participants, id: :uuid do |t|
      t.string  :reference, null: false
      t.integer :access_count, default: 0
      t.string  :opted_in
      t.text    :details

      t.timestamps
    end

    add_index :participants, :reference, unique: true
  end
end
