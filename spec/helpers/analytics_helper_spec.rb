require 'rails_helper'

RSpec.describe AnalyticsHelper, type: :helper do
  let(:record) { DisclosureCheck.new(kind: kind) }
  let(:kind) { CheckKind::CAUTION }

  before do
    allow(helper).to receive(:current_disclosure_check).and_return(record)
  end

  describe '#analytics_tracking_id' do
    it 'retrieves the environment variable' do
      expect(ENV).to receive(:[]).with('GA_TRACKING_ID')
      helper.analytics_tracking_id
    end
  end

  describe '#track_transaction' do
    before do
      allow(record).to receive(:id).and_return('12345')
      allow(record).to receive(:kind).and_return('caution')
    end

    it 'sets the transaction attributes to track' do
      helper.track_transaction(name: 'whatever')

      expect(
        helper.content_for(:transaction_data)
      ).to eq("{\"id\":\"12345\",\"sku\":\"caution\",\"quantity\":1,\"name\":\"whatever\"}")
    end

    context 'custom dimensions' do
      it 'sets the transaction attributes to track' do
        helper.track_transaction(name: 'whatever', dimensions: { spent: 'yes' } )

        expect(
          helper.content_for(:transaction_data)
        ).to match(/"name":"whatever","dimension1":"yes"/)
      end
    end
  end

  describe '#transaction_sku' do
    before do
      allow(record).to receive(attr_name).and_return(attr_name)
    end

    context 'conviction_subtype is present' do
      let(:attr_name) { 'conviction_subtype' }
      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context 'conviction_type is present' do
      let(:attr_name) { 'conviction_type' }
      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context 'caution_type is present' do
      let(:attr_name) { 'caution_type' }
      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context 'kind is present' do
      let(:attr_name) { 'kind' }
      it { expect(helper.transaction_sku).to eq(attr_name) }
    end
  end

  describe '#transaction_sku when not enough steps have been completed' do
    context '`current_disclosure_check` is not present' do
      let(:record) { nil }
      it { expect(helper.transaction_sku).to eq('unknown') }
    end

    context '`current_disclosure_check` is present, but `kind` is not present' do
      let(:kind) { nil }
      it { expect(helper.transaction_sku).to eq('unknown') }
    end
  end

  describe '#ga_spent?' do
    context 'for a date in the past' do
      let(:date) { 1.year.ago.to_date }
      it { expect(helper.ga_spent?(date)).to eq('yes') }
    end

    context 'for a date in the present' do
      let(:date) { Date.current }
      it { expect(helper.ga_spent?(date)).to eq('no') }
    end

    context 'for a date in the future' do
      let(:date) { 1.year.from_now.to_date }
      it { expect(helper.ga_spent?(date)).to eq('no') }
    end

    context 'when the argument is not a date' do
      let(:date) { 'foobar' }
      it { expect(helper.ga_spent?(date)).to eq('no_date') }
    end
  end
end
