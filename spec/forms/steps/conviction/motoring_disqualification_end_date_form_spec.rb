require 'spec_helper'

RSpec.describe Steps::Conviction::MotoringDisqualificationEndDateForm do
  it_behaves_like 'a date question form', attribute_name: :motoring_disqualification_end_date, allow_empty_date: true, allow_future: true do
    # TODO: move this context to the shared examples once all dates are migrated
    context 'casting the date from multi parameters' do
      context 'when date is valid' do
        let(:date_value) { [nil, 2008, 11, 22] }
        it { expect(subject).to be_valid }
      end

      context 'when date is not valid' do
        let(:date_value) { [nil, 18, 11, 22] } # 2-digits year (18)
        it { expect(subject).not_to be_valid }
      end
    end
  end
end
