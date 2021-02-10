require 'rails_helper'

RSpec.describe Calculators::Multiples::MultipleOffensesCalculator do
  subject { described_class.new(disclosure_report) }

  let(:disclosure_report) { DisclosureReport.new }
  let(:first_proceeding_group) { disclosure_report.check_groups.build }
  let(:second_proceeding_group) { disclosure_report.check_groups.build }

  let(:first_proceedings) { subject.proceedings.first }
  let(:second_proceedings) { subject.proceedings.second }

  def save_report
    disclosure_report.completed!
  end

  context 'scenario 1' do
    # Jack age 21 was convicted of possession of an offensive weapon on 25/01/2017 and received
    # - a two-year conditional discharge order. Jack’s conviction would become spent on 25/01/2019.
    #
    # On 10/12/2018 Jack was convicted of battery and received:
    # -  a 12-month community order. This conviction would become spent on 10/12/2020.
    #
    # Outcome:
    # - First conviction is spent on 25/01/2019
    # - Second conviction is spent on 10/12/2020

    let(:first_conviction_date) { Date.new(2017, 1, 25) }
    let(:second_conviction_date) { Date.new(2018, 12, 10) }

    let(:conditional_discharge_order) do
      build(
        :disclosure_check,
        :adult,
        :with_discharge_order,
        :completed,
        known_date: first_conviction_date,
        conviction_date: first_conviction_date,
        conviction_length: 2,
        conviction_length_type: ConvictionLengthType::YEARS
      )
    end

    let(:community_order) do
      build(
        :disclosure_check,
        :with_community_order,
        :completed,
        known_date: second_conviction_date,
        conviction_date: second_conviction_date,
        conviction_length: 12,
        conviction_length_type: ConvictionLengthType::MONTHS
      )
    end

    before do
      first_proceeding_group.disclosure_checks << conditional_discharge_order
      second_proceeding_group.disclosure_checks << community_order

      save_report
    end

    it 'returns the date for the first proceeeding' do
      expect(subject.spent_date_for(first_proceedings)).to eq(Date.new(2019, 1, 25))
    end

    it 'returns indefinite for the second proceeding' do
      expect(subject.spent_date_for(second_proceedings)).to eq(Date.new(2020, 12, 10))
    end
  end

  context 'scenario 2' do
    # On 01/08/2009 Alex, age 18, was convicted of common assault and given:
    # -  a three-month suspended custodial sentence. The rehabilitation period would end on 01/11/2011.
    #
    # Alex was then convicted of battery on 10/06/2011. He was sentenced to:
    # - A six-month custodial sentence (would become ‘spent’ 10/12/2013)
    # - Restraining order until further order (will be ‘unspent’ until further notice)
    # - A fine of £150.00 (would become ‘spent’ 10/06/2012)
    #
    # Outcome:
    # - First conviction is spent on 10 December 2013
    # - Second conviction is unspent until further notice

    let(:first_conviction_date) { Date.new(2009, 8, 1) }
    let(:second_conviction_date) { Date.new(2011, 6, 10) }

    let(:suspended_prison_sentence) do
      build(
        :disclosure_check,
        :suspended_prison_sentence,
        :completed,
        known_date: first_conviction_date,
        conviction_date: first_conviction_date,
        conviction_length: 3
      )
    end

    let(:custodial_sentence) do
      build(
        :disclosure_check,
        :with_prison_sentence,
        :completed,
        known_date: second_conviction_date,
        conviction_date: second_conviction_date,
        conviction_length: 6
      )
    end

    # relevant order
    let(:restraining_order) do
      build(
        :disclosure_check,
        :with_restraining_order,
        :completed,
        known_date: second_conviction_date,
        conviction_date: second_conviction_date,
        conviction_length: nil,
        conviction_length_type: ConvictionLengthType::INDEFINITE
      )
    end

    let(:financial_fine) do
      build(
        :disclosure_check,
        :adult,
        :with_fine,
        :completed,
        known_date: second_conviction_date,
        conviction_date: second_conviction_date
      )
    end

    before do
      first_proceeding_group.disclosure_checks << suspended_prison_sentence
      second_proceeding_group.disclosure_checks << custodial_sentence
      second_proceeding_group.disclosure_checks << restraining_order
      second_proceeding_group.disclosure_checks << financial_fine

      save_report
    end

    it 'returns the date for the first proceeeding' do
      expect(subject.spent_date_for(first_proceedings)).to eq(Date.new(2013, 12, 9))
    end

    it 'returns indefinite for the second proceeding' do
      expect(subject.spent_date_for(second_proceedings)).to eq(ResultsVariant::INDEFINITE)
    end
  end

  context 'scenario 3' do
    # Sandra, age 19, was convicted of theft on 20 May 2015 and receives:
    # - a 4 month custodial sentence. This conviction would become spent on 20 September 2017.
    #
    # On 1 February 2017, she is convicted of battery and receives:
    # - a 3 month suspended custodial sentence. This conviction would become spent on 1 May 2019.
    #
    # Outcome:
    # - Both convictions will remain unspent until 01/05/2019

    let(:first_conviction_date) { Date.new(2015, 5, 20) }
    let(:second_conviction_date) { Date.new(2017, 2, 1) }

    let(:custodial_sentence) do
      build(
        :disclosure_check,
        :with_prison_sentence,
        :completed,
        known_date: first_conviction_date,
        conviction_date: first_conviction_date,
        conviction_length: 4
      )
    end

    let(:suspended_prison_sentence) do
      build(
        :disclosure_check,
        :suspended_prison_sentence,
        :completed,
        known_date: second_conviction_date,
        conviction_date: second_conviction_date,
        conviction_length: 3
      )
    end

    before do
      first_proceeding_group.disclosure_checks << custodial_sentence
      second_proceeding_group.disclosure_checks << suspended_prison_sentence

      save_report
    end

    it 'returns the date for the first proceeeding' do
      expect(subject.spent_date_for(first_proceedings)).to eq(Date.new(2019, 4, 30))
    end

    it 'returns indefinite for the second proceeding' do
      expect(subject.spent_date_for(second_proceedings)).to eq(Date.new(2019, 4, 30))
    end
  end

  context 'scenario 4' do
    # Ranjit, age 32, was convicted of fraud on 20 May 2015 and receives:
    # -  a 3 month custodial sentence. This conviction would become spent on 20 August 2017.
    #
    # On 1 February 2018 he was convicted of a further offence for which he was given:
    # -  a fine of £200. This conviction would become spent on 1 February 2019.
    #
    # Outcome:
    # - First conviction is spent on 20/08/2017
    # - Second conviction is spent on 01/02/2019

    let(:first_conviction_date) { Date.new(2015, 5, 20) }
    let(:second_conviction_date) { Date.new(2018, 2, 1) }

    let(:custodial_sentence) do
      build(
        :disclosure_check,
        :with_prison_sentence,
        :completed,
        known_date: first_conviction_date,
        conviction_date: first_conviction_date,
        conviction_length: 3
      )
    end

    let(:financial_fine) do
      build(
        :disclosure_check,
        :adult,
        :with_fine,
        :completed,
        known_date: second_conviction_date,
        conviction_date: second_conviction_date
      )
    end

    before do
      first_proceeding_group.disclosure_checks << custodial_sentence
      second_proceeding_group.disclosure_checks << financial_fine

      save_report
    end

    it 'returns the date for the first proceeeding' do
      expect(subject.spent_date_for(first_proceedings)).to eq(Date.new(2017, 8, 19))
    end

    it 'returns indefinite for the second proceeding' do
      expect(subject.spent_date_for(second_proceedings)).to eq(Date.new(2019, 2, 1))
    end
  end

  context 'scenario 5' do
    # Andrea, age 38, was convicted on 2 August 2015 of assaulting a supporter at a football match, she received:
    # -  a 4 month custodial sentence
    # - a football banning order lasting 6 years. This conviction would become spent on 2 August 2021.
    #
    # On 5 February 2018, she was convicted of criminal damage and received:
    # -  a fine of £100.
    #
    # Outcome:
    # - First conviction is spent on 02/08/2021
    # - Second conviction is spent on 05/02/2019

    let(:first_conviction_date) { Date.new(2015, 8, 2) }
    let(:second_conviction_date) { Date.new(2018, 2, 5) }

    let(:custodial_sentence) do
      build(
        :disclosure_check,
        :with_prison_sentence,
        :completed,
        known_date: first_conviction_date,
        conviction_date: first_conviction_date,
        conviction_length: 4
      )
    end

    let(:football_banning_order) do
      build(
        :disclosure_check,
        :with_serious_crime_prevention,
        :completed,
        known_date: first_conviction_date,
        conviction_date: first_conviction_date,
        conviction_length: 6,
        conviction_length_type: ConvictionLengthType::YEARS
      )
    end

    let(:financial_fine) do
      build(
        :disclosure_check,
        :adult,
        :with_fine,
        :completed,
        known_date: second_conviction_date,
        conviction_date: second_conviction_date
      )
    end

    before do
      first_proceeding_group.disclosure_checks << custodial_sentence
      first_proceeding_group.disclosure_checks << football_banning_order
      second_proceeding_group.disclosure_checks << financial_fine

      save_report
    end

    it 'returns the date for the first proceeeding' do
      expect(subject.spent_date_for(first_proceedings)).to eq(Date.new(2021, 8, 2))
    end

    it 'returns indefinite for the second proceeding' do
      expect(subject.spent_date_for(second_proceedings)).to eq(Date.new(2019, 2, 5))
    end
  end

  context 'scenario 6' do
    # Darren was convicted of attempted murder on 12 September 2004.
    # - He was sentenced to 5 years in prison. This conviction will never be spent.
    #
    # He had 2 previous convictions:
    # - 10 August 1998 - he was convicted of assault resulting in:
    # 	- a 12 month community order and a fine.
    # - 10 July 2004 - he was convicted of harassment resulting in:
    # 	-  a fine of £100
    #
    # Outcome:
    # - Conviction of attempted murder will never be spent
    # - Conviction of August 1998 is spent on 10 August 2000
    # - Conviction of July 2004 will never be spent
    #
    # On 7 February 2012, Darren was is convicted for a separate incident of theft, resulting in:
    # - a 6 month suspended sentence
    #
    # Outcome:
    # - Conviction of attempted murder will never be spent
    # - Conviction of August 1998 is spent on 10 August 2000
    # - Conviction of July 2004 will never be spent
    # - Conviction of February 2012 is spent on 07/08/2014

    let(:first_conviction_date)  { Date.new(1998, 8, 10) }
    let(:second_conviction_date) { Date.new(2004, 7, 10) }
    let(:third_conviction_date)  { Date.new(2004, 9, 12) }
    let(:forth_conviction_date)  { Date.new(2012, 2, 7) }

    let(:conviction_of_august_1998) do
      build(
        :disclosure_check,
        :with_community_order,
        :completed,
        known_date: first_conviction_date,
        conviction_date: first_conviction_date,
        conviction_length: 12
      )
    end

    let(:conviction_of_july_2004) do
      build(
        :disclosure_check,
        :adult,
        :with_fine,
        :completed,
        known_date: second_conviction_date,
        conviction_date: second_conviction_date,
      )
    end

    let(:conviction_of_september_2004) do
      build(
        :disclosure_check,
        :with_prison_sentence,
        :completed,
        known_date: third_conviction_date,
        conviction_date: third_conviction_date,
        conviction_length: 5,
        conviction_length_type: ConvictionLengthType::YEARS
      )
    end

    let(:third_proceeding_group) { disclosure_report.check_groups.build }
    let(:third_proceedings) { subject.proceedings.third }

    context 'before 7 February 2012' do
      before do
        first_proceeding_group.disclosure_checks << conviction_of_august_1998
        second_proceeding_group.disclosure_checks << conviction_of_july_2004
        third_proceeding_group.disclosure_checks << conviction_of_september_2004

        save_report
      end

      it 'returns the date for the first proceeeding' do
        expect(subject.spent_date_for(first_proceedings)).to eq(Date.new(2000, 8, 10))
      end

      it 'returns `never spent` for the second proceeding' do
        expect(subject.spent_date_for(second_proceedings)).to eq(ResultsVariant::NEVER_SPENT)
      end

      it 'returns `never spent` for the third proceeding' do
        expect(subject.spent_date_for(third_proceedings)).to eq(ResultsVariant::NEVER_SPENT)
      end
    end


    # third conviction 12/9/2004
    # duration: 5 years, meaning: never spent!
    # but duration is up to 12 9 2009
    context 'after 7 February 2012' do
      let(:forth_proceeding_group) { disclosure_report.check_groups.build }
      let(:forth_proceedings) { subject.proceedings.fourth }

      # On 7 February 2012, Darren was is convicted for a separate incident of theft, resulting in:
      # - a 6 month suspended sentence
      let(:conviction_of_february_2012) do
        build(
          :disclosure_check,
          :suspended_prison_sentence,
          :completed,
          known_date: forth_conviction_date,
          conviction_date: forth_conviction_date,
          conviction_length: 6
        )
      end

      before do
        first_proceeding_group.disclosure_checks << conviction_of_august_1998
        second_proceeding_group.disclosure_checks << conviction_of_july_2004
        third_proceeding_group.disclosure_checks << conviction_of_september_2004
        forth_proceeding_group.disclosure_checks << conviction_of_february_2012

        save_report
      end

      it 'returns the date for the first proceeeding' do
        expect(subject.spent_date_for(first_proceedings)).to eq(Date.new(2000, 8, 10))
      end

      it 'returns `never spent` for the second proceeding' do
        expect(subject.spent_date_for(second_proceedings)).to eq(ResultsVariant::NEVER_SPENT)
      end

      it 'returns `never spent` for the third proceeding' do
        expect(subject.spent_date_for(third_proceedings)).to eq(ResultsVariant::NEVER_SPENT)
      end

      # This becomes spent on 7 August 2014 as long as he is not convicted of a further offence during this time.
      it 'returns the date for the forth proceeding' do
        expect(subject.spent_date_for(forth_proceedings)).to eq(Date.new(2014, 8, 6))
      end
    end
  end

  context 'scenario 7' do
    let(:third_proceeding_group) { disclosure_report.check_groups.build }
    let(:third_proceedings) { subject.proceedings.third }

    let(:conviction_date_A)  { Date.new(2001, 1, 1) } # spent on 1, 1, 2003
    let(:conviction_date_B)  { Date.new(2000, 6, 1) } # spent on 1, 6, 2001
    let(:conviction_date_C)  { Date.new(2002, 3, 1) } # spent on 28 feb 2012

    let(:conviction_A) do
      [
        build(
          :disclosure_check,
          :with_prison_sentence,
          :completed,
          known_date: conviction_date_A,
          conviction_date: conviction_date_A,
          conviction_length: 2,
          conviction_length_type: ConvictionLengthType::YEARS
        ),
        build(
          :disclosure_check,
          :adult,
          :with_discharge_order,
          :completed,
          known_date: conviction_date_A,
          conviction_date: conviction_date_A,
          conviction_length: 3,
          conviction_length_type: ConvictionLengthType::YEARS
        )
      ]
    end

    let(:conviction_B) do
      build(
        :disclosure_check,
        :adult,
        :with_fine,
        :completed,
        known_date: conviction_date_B,
        conviction_date: conviction_date_B,
      )
    end

    let(:conviction_C) do
      build(
        :disclosure_check,
        :with_prison_sentence,
        :completed,
        known_date: conviction_date_C,
        conviction_date: conviction_date_C,
        conviction_length: 3,
        conviction_length_type: ConvictionLengthType::YEARS
      )
    end

    before do
      first_proceeding_group.disclosure_checks << conviction_A
      second_proceeding_group.disclosure_checks << conviction_B
      third_proceeding_group.disclosure_checks << conviction_C

      save_report
    end

    it 'dates' do
      expect(subject.spent_date_for(first_proceedings)).to eq(Date.new(2012, 2, 28))
      expect(subject.spent_date_for(second_proceedings)).to eq(Date.new(2012, 2, 28))
      expect(subject.spent_date_for(third_proceedings)).to eq(Date.new(2012, 2, 28))
    end
  end
end
