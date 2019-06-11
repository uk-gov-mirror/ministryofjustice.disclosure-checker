class RemoveUnusedConvictionFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :disclosure_checks, :custodial_sentence, :string
    remove_column :disclosure_checks, :discharge, :string
    remove_column :disclosure_checks, :financial, :string
    remove_column :disclosure_checks, :military, :string
    remove_column :disclosure_checks, :motoring, :string
    remove_column :disclosure_checks, :rehabilitation_prevention_order, :string
  end
end
