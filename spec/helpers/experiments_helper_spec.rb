require 'rails_helper'

RSpec.describe ExperimentsHelper, type: :helper do
  describe '#bail_enabled?' do
    let(:dev_tools_enabled) { true }
    let(:development_env) { true }

    before do
      allow(ENV).to receive(:key?).with('DEV_TOOLS_ENABLED').and_return(dev_tools_enabled)
      allow(Rails.env).to receive(:development?).and_return(development_env)
    end

    context 'on development environments' do
      it { expect(helper.bail_enabled?).to eq(true) }
    end

    context 'on production environments with DEV_TOOLS_ENABLED' do
      let(:dev_tools_enabled) { true }
      let(:development_env) { false }

      it { expect(helper.bail_enabled?).to eq(true) }
    end

    context 'on production environments without DEV_TOOLS_ENABLED' do
      let(:dev_tools_enabled) { false }
      let(:development_env) { false }

      it { expect(helper.bail_enabled?).to eq(false) }
    end
  end
end
