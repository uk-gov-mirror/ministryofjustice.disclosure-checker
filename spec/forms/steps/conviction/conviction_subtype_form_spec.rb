require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionSubtypeForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      conviction_subtype: conviction_subtype,
    }
  end

  let(:disclosure_check) {
    instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_subtype: nil)
  }

  let(:conviction_type) { 'referral_supervision_yro' } # any conviction with children will do
  let(:conviction_subtype) { nil }

  subject { described_class.new(arguments) }

  describe '#i18n_attribute' do
    it 'returns the key that will be used to translate legends and hints' do
      expect(subject.i18n_attribute).to eq(ConvictionType.new(:referral_supervision_yro))
    end
  end

  # Note: no need to check for all the returned values, as we cover this extensively
  # in the value-object spec `spec/value_objects/conviction_type_spec.rb`
  describe '#values' do
    it 'returns the relevant values (children of the conviction type)' do
      expect(subject.values).to include(
        ConvictionType.new(:referral_order),
        ConvictionType.new(:supervision_order),
        ConvictionType.new(:youth_rehabilitation_order)
      )
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :conviction_subtype, example_value: 'referral_order'

    context 'when conviction type is motoring' do
      context 'and conviction subtype is youth_penalty_notice' do
        let(:conviction_type) { 'youth_motoring' }
        let(:conviction_subtype) { 'youth_penalty_notice' }

        it 'saves the record with motoring endorsement saved with `yes` value' do
          expect(disclosure_check).to receive(:update).with(
            conviction_subtype: conviction_subtype,
            # Dependent attributes to be reset
            known_date: nil,
            conviction_bail: nil,
            conviction_bail_days: nil,
            conviction_length: nil,
            conviction_length_type: nil,
            compensation_paid: nil,
            compensation_payment_date: nil,
            motoring_endorsement: GenericYesNo::YES,
          ).and_return(true)

          expect(subject.save).to be(true)
        end

        context 'when conviction_subtype is already the same on the model' do
          let(:disclosure_check) {
            instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_subtype: conviction_subtype)
          }

          it 'does not save the record but returns true' do
            expect(disclosure_check).to_not receive(:update)
            expect(subject.save).to be(true)
          end
        end
      end

      context 'and conviction subtype is adult_penalty_notice' do
        let(:conviction_type) { 'adult_motoring' }
        let(:conviction_subtype) { 'adult_penalty_notice' }

        it 'saves the record with motoring endorsement saved with `yes` value' do
          expect(disclosure_check).to receive(:update).with(
            conviction_subtype: conviction_subtype,
            # Dependent attributes to be reset
            known_date: nil,
            conviction_bail: nil,
            conviction_bail_days: nil,
            conviction_length: nil,
            conviction_length_type: nil,
            compensation_paid: nil,
            compensation_payment_date: nil,
            motoring_endorsement: GenericYesNo::YES,
          ).and_return(true)

          expect(subject.save).to be(true)
        end

        context 'when conviction_subtype is already the same on the model' do
          let(:disclosure_check) {
            instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_subtype: conviction_subtype)
          }

          it 'does not save the record but returns true' do
            expect(disclosure_check).to_not receive(:update)
            expect(subject.save).to be(true)
          end
        end
      end
    end

    context 'when form is valid' do
      let(:conviction_subtype) { 'referral_order' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          conviction_subtype: conviction_subtype,
          # Dependent attributes to be reset
          known_date: nil,
          conviction_bail: nil,
          conviction_bail_days: nil,
          conviction_length: nil,
          conviction_length_type: nil,
          compensation_paid: nil,
          compensation_payment_date: nil,
          motoring_endorsement: nil,
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'when conviction_subtype is already the same on the model' do
        let(:disclosure_check) {
          instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_subtype: conviction_subtype)
        }

        it 'does not save the record but returns true' do
          expect(disclosure_check).to_not receive(:update)
          expect(subject.save).to be(true)
        end
      end
    end
  end
end
