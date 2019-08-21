require 'i18n/tasks'
require 'rails_helper'

RSpec.describe 'I18n' do
  let(:i18n) { I18n::Tasks::BaseTask.new }
  let(:missing_keys) { i18n.missing_keys }

  it 'does not have missing keys' do
    expect(missing_keys).to be_empty,
                            "Missing #{missing_keys.leaves.count} i18n keys, run `i18n-tasks missing' to show them"
  end

  # Note: The following sanity checks will ensure we have the same keys and values in both places,
  # so we don't inadvertently update just once place and not the other.
  # It doesn't matter the order of the keys in the locales, what matters is the content.
  #
  context 'shared dictionaries sanity checks' do
    it 'caution types in `helpers.yml` matches caution types in `results.yml`' do
      expect(
        i18n.tree('en.helpers.label.steps_caution_caution_type_form.caution_type').to_hash
      ).to eq(
        i18n.tree('en.results/caution.caution_type.answers').to_hash
      )
    end

    it 'convictions types in `helpers.yml` matches convictions types in `results.yml`' do
      expect(
        i18n.tree('en.helpers.label.steps_conviction_conviction_type_form.conviction_type').to_hash
      ).to eq(
        i18n.tree('en.results/conviction.conviction_type.answers').to_hash
      )
    end

    it 'convictions subtypes in `helpers.yml` matches convictions subtypes in `results.yml`' do
      expect(
        i18n.tree('en.helpers.label.steps_conviction_conviction_subtype_form.conviction_subtype').to_hash
      ).to eq(
        i18n.tree('en.results/conviction.conviction_subtype.answers').to_hash
      )
    end
  end
end
