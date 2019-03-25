require 'rails_helper'

RSpec.describe Steps::Caution::ResultController, type: :controller do
  it_behaves_like 'a completion step controller'

  describe '#show' do
    let(:disclosure_check) { build(:disclosure_check) }
    let(:caution_result_presenter) { CautionResultPresenter.new(disclosure_check) }

    before do
      allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
    end

    it 'assigns the presenter' do
      allow(CautionResultPresenter).to receive(:new).with(disclosure_check).and_return(caution_result_presenter)

      get :show
      expect(response).to render_template(:show)
      expect(assigns[:presenter]).to eq(caution_result_presenter)
    end
  end
end
