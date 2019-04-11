class AddCustodialSentenceToDisclosureCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :disclosure_checks, :custodial_sentence, :string
  end
end
