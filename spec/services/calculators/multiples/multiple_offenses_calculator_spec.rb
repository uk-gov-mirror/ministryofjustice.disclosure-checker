require 'rails_helper'

RSpec.describe Calculators::Multiples::MultipleOffensesCalculator do
  subject { described_class.new(disclosure_report) }

  let(:disclosure_report) { instance_double(DisclosureReport, check_groups: groups_result_set, completed?: true) }
  let(:groups_result_set) { double('groups_result_set', with_completed_checks: [check_group1, check_group2]) }

  let(:check_group1) { instance_double(CheckGroup, id: '100', disclosure_checks: [disclosure_check1, disclosure_check2]) }
  let(:check_group2) { instance_double(CheckGroup, id: '200', disclosure_checks: [disclosure_check3]) }

  let(:disclosure_check1) { instance_double(DisclosureCheck, kind: 'conviction') }
  let(:disclosure_check2) { instance_double(DisclosureCheck, kind: 'conviction') }
  let(:disclosure_check3) { instance_double(DisclosureCheck, kind: 'caution') }

  let(:same_proceedings) { subject.results['100'] }
  let(:separate_proceedings) { subject.results['200'] }

  before do
    # Note: because these are doubles, the method does not work, so we emulate it
    allow(check_group1).to receive(:multiple_sentences?).and_return(true)
    allow(check_group2).to receive(:multiple_sentences?).and_return(false)
  end

  context '#process!' do
    it 'adds to the results the check groups having more than one disclosure check' do
      expect(subject.results['100']).to be_kind_of(Calculators::Multiples::SameProceedings)
    end

    it 'adds to the results the check groups having only one disclosure check' do
      expect(subject.results['200']).to be_kind_of(Calculators::Multiples::SeparateProceedings)
    end
  end

  # NOTE: Working with doubles so it is a lot more easier to understand what is going on
  describe '#spent_date_for' do
    context 'conviction with 2 sentences, and one simple caution' do
      before do
        allow(subject).to receive(:proceedings).and_return([conviction_1, conviction_2])
      end

      let(:conviction_1) {
        instance_double(
          Calculators::Multiples::SameProceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 1, 1),
          spent_date: Date.new(2022, 1, 1),
        )
      }

      let(:conviction_2) {
        instance_double(
          Calculators::Multiples::SeparateProceedings,
          conviction?: false,
          conviction_date: nil,
          spent_date: ResultsVariant::SPENT_SIMPLE,
        )
      }

      it 'returns the spent date for the matching check group' do
        expect(subject.spent_date_for(conviction_1)).to eq(Date.new(2022, 1, 1))
        expect(subject.spent_date_for(conviction_2)).to eq(ResultsVariant::SPENT_SIMPLE)
      end
    end

    context 'conviction with 2 sentences, and another, separate proceedings conviction' do
      before do
        allow(subject).to receive(:proceedings).and_return([conviction_1, conviction_2])
      end

      context 'all sentences are dates' do
        context 'there is overlapping of rehabilitation periods' do
          let(:conviction_1) {
            instance_double(
              Calculators::Multiples::SameProceedings,
              conviction?: true,
              conviction_date: Date.new(2020, 1, 1),
              spent_date: Date.new(2022, 1, 1),
            )
          }

          let(:conviction_2) {
            instance_double(
              Calculators::Multiples::SeparateProceedings,
              conviction?: true,
              conviction_date: Date.new(2021, 1, 1),
              spent_date: Date.new(2025, 1, 1),
            )
          }

          it 'returns the spent date for the matching check group' do
            expect(subject.spent_date_for(conviction_1)).to eq(Date.new(2025, 1, 1))
            expect(subject.spent_date_for(conviction_2)).to eq(Date.new(2025, 1, 1))
          end
        end

        context 'there is no overlapping of rehabilitation periods' do
          let(:conviction_1) {
            instance_double(
              Calculators::Multiples::SameProceedings,
              conviction?: true,
              conviction_date: Date.new(2020, 1, 1),
              spent_date: Date.new(2022, 1, 1),
            )
          }

          let(:conviction_2) {
            instance_double(
              Calculators::Multiples::SeparateProceedings,
              conviction?: true,
              conviction_date: Date.new(2023, 1, 1),
              spent_date: Date.new(2025, 1, 1),
            )
          }

          it 'returns the spent date for the matching check group' do
            expect(subject.spent_date_for(conviction_1)).to eq(Date.new(2022, 1, 1))
            expect(subject.spent_date_for(conviction_2)).to eq(Date.new(2025, 1, 1))
          end
        end
      end

      # Rules (assuming there are overlaps):
      #
      #   - Everything (that has an end date) given before a "never spent"
      #     conviction becomes never spent.
      #
      #   - Everything afterwards is not affected by the never spent.
      #
      context 'one of the sentences has never spent length' do
        let(:conviction_1) {
          instance_double(
            Calculators::Multiples::SameProceedings,
            conviction?: true,
            conviction_date: Date.new(2020, 1, 1),
            spent_date: spent_date_1,
          )
        }

        let(:conviction_2) {
          instance_double(
            Calculators::Multiples::SeparateProceedings,
            conviction?: true,
            conviction_date: Date.new(2021, 1, 1),
            spent_date: spent_date_2,
          )
        }

        context 'never spent sentence goes in the first conviction' do
          let(:spent_date_1) { ResultsVariant::NEVER_SPENT }
          let(:spent_date_2) { Date.new(2023, 1, 1) }

          it 'returns the spent date for the matching check group' do
            expect(subject.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
            expect(subject.spent_date_for(conviction_2)).to eq(Date.new(2023, 1, 1))
          end
        end

        context 'never spent sentence goes in the second conviction' do
          let(:spent_date_1) { Date.new(2023, 1, 1) }
          let(:spent_date_2) { ResultsVariant::NEVER_SPENT }

          it 'returns the spent date for the matching check group' do
            expect(subject.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
            expect(subject.spent_date_for(conviction_2)).to eq(ResultsVariant::NEVER_SPENT)
          end
        end
      end

      context 'one of the sentences has indefinite length' do
        let(:conviction_1) {
          instance_double(
            Calculators::Multiples::SameProceedings,
            conviction?: true,
            conviction_date: Date.new(2020, 1, 1),
            spent_date: spent_date_1,
          )
        }

        let(:conviction_2) {
          instance_double(
            Calculators::Multiples::SeparateProceedings,
            conviction?: true,
            conviction_date: Date.new(2021, 1, 1),
            spent_date: spent_date_2,
          )
        }

        context 'indefinite sentence goes in the first conviction' do
          let(:spent_date_1) { ResultsVariant::INDEFINITE }
          let(:spent_date_2) { Date.new(2023, 1, 1) }

          it 'returns the spent date for the matching check group' do
            expect(subject.spent_date_for(conviction_1)).to eq(ResultsVariant::INDEFINITE)
            expect(subject.spent_date_for(conviction_2)).to eq(Date.new(2023, 1, 1))
          end
        end

        context 'indefinite sentence goes in the second conviction' do
          let(:spent_date_1) { Date.new(2023, 1, 1) }
          let(:spent_date_2) { ResultsVariant::INDEFINITE }

          it 'returns the spent date for the matching check group' do
            expect(subject.spent_date_for(conviction_1)).to eq(ResultsVariant::INDEFINITE)
            expect(subject.spent_date_for(conviction_2)).to eq(ResultsVariant::INDEFINITE)
          end
        end
      end

      context 'one of the sentences is never spent and the other is indefinite' do
        let(:conviction_1) {
          instance_double(
            Calculators::Multiples::SameProceedings,
            conviction?: true,
            conviction_date: Date.new(2020, 1, 1),
            spent_date: spent_date_1,
          )
        }

        let(:conviction_2) {
          instance_double(
            Calculators::Multiples::SeparateProceedings,
            conviction?: true,
            conviction_date: Date.new(2021, 1, 1),
            spent_date: spent_date_2,
          )
        }

        context 'never spent sentence goes in the first conviction and indefinite in the second conviction' do
          let(:spent_date_1) { ResultsVariant::NEVER_SPENT }
          let(:spent_date_2) { ResultsVariant::INDEFINITE }

          it 'returns the spent date for the matching check group' do
            expect(subject.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
            expect(subject.spent_date_for(conviction_2)).to eq(ResultsVariant::INDEFINITE)
          end
        end

        context 'indefinite sentence goes in the first conviction and never spent in the second conviction' do
          let(:spent_date_1) { ResultsVariant::INDEFINITE }
          let(:spent_date_2) { ResultsVariant::NEVER_SPENT }

          it 'returns the spent date for the matching check group' do
            expect(subject.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
            expect(subject.spent_date_for(conviction_2)).to eq(ResultsVariant::NEVER_SPENT)
          end
        end
      end
    end

    context '3 separate proceedings convictions' do
      before do
        allow(subject).to receive(:proceedings).and_return([conviction_1, conviction_2, conviction_3])
      end

      let(:conviction_1) {
        instance_double(
          Calculators::Multiples::SeparateProceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 1, 1),
          spent_date: Date.new(2021, 1, 1),
        )
      }

      let(:conviction_2) {
        instance_double(
          Calculators::Multiples::SeparateProceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 10, 25),
          spent_date: ResultsVariant::NEVER_SPENT,
        )
      }

      let(:conviction_3) {
        instance_double(
          Calculators::Multiples::SeparateProceedings,
          conviction?: true,
          conviction_date: Date.new(2023, 1, 1),
          spent_date: Date.new(2025, 1, 1),
        )
      }

      it 'returns the spent date for the matching check group' do
        expect(subject.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
        expect(subject.spent_date_for(conviction_2)).to eq(ResultsVariant::NEVER_SPENT)
        expect(subject.spent_date_for(conviction_3)).to eq(Date.new(2025, 1, 1))
      end
    end
  end

  describe '#all_spent?' do
    before do
      allow(same_proceedings).to receive(:spent_date).and_return(spent_dates[0])
      allow(separate_proceedings).to receive(:spent_date).and_return(spent_dates[1])
    end

    context 'when there is an offence that will never be spent' do
      let(:spent_dates) { [ResultsVariant::NEVER_SPENT, Date.yesterday] }

      it 'returns false' do
        expect(subject.all_spent?).to eq(false)
      end
    end

    context 'when there is an offence with `spent_simple`' do
      let(:spent_dates) { [Date.yesterday, ResultsVariant::SPENT_SIMPLE] }

      it 'considers the spent_simple as spent' do
        expect(subject.all_spent?).to eq(true)
      end
    end

    context 'when there is an offence with `indefinite`' do
      let(:spent_dates) { [ResultsVariant::INDEFINITE, Date.tomorrow] }

      it 'excludes the `indefinite` offence, and check the other dates' do
        expect(subject.all_spent?).to eq(false)
      end
    end

    context 'when there are dates' do
      let(:spent_dates) { [Date.yesterday, Date.tomorrow] }

      it 'checks if all the dates are in the past' do
        expect(subject.all_spent?).to eq(false)
      end
    end

    context 'when there are dates' do
      let(:spent_dates) { [Date.yesterday, Date.yesterday-3.days] }

      it 'checks if all the dates are in the past' do
        expect(subject.all_spent?).to eq(true)
      end
    end
  end
end
